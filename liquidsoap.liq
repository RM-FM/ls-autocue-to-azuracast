# Create your own API key in Azuracast and add it here
autocue_api_key = "add-your-azuracast-api-key-here"

# Function to store data in Azuracast
def autocue_azuracast_update(song_id,payload) =

    # Extract station_id from Azurecast internal API URL
    matches = r/internal\/(\d+)\/liquidsoap/.exec(azuracast_api_url)
    group = list.nth(matches,0)
    station_id = snd(group)

    # Construct API URL for song/file update
    url = "#{azuracast_api_url}/../../../station/#{station_id}/file/#{song_id}"      
    log(level=4, label="auctocue_azuracast_update", "#{payload}")  

    # Send API update (PUT) request to Azuracast
    try
        http.put(url,
            headers=[
                ("Content-Type", "application/json"),
                ("User-Agent", "Liquidsoap Autocue"),
                ("X-Api-Key", "#{autocue_api_key}")
            ],
            timeout=2.0,
            data=payload
        )
        log(level=2, label="auctocue_azuracast_update", "Autocue values for song_id #{song_id} successfully stored in Azuracast.") 
    # API error handling
    catch err do
        log(level=1, label="auctocue_azuracast_update", "Storing autocue values for song_id #{song_id} in Azuracast failed: #{error.kind(err)} - #{error.message(err)}")
    end
end

# Read autocue metadata if available
def autocue_update(m) =

  # Convert string to float safely
  def safe_float_of_string(str,~default=0.) =
    try
      float_of_string(default=default,str)
    catch _ do
      default
    end
  end

  # Check whether autocue data and song_id is set
  if m["liq_autocue"] == "internal" and m["song_id"] != "" then
    # Contruct API payload message
    j = json()
    j.add("fade_overlap", safe_float_of_string(m["liq_fade_out"]))
    j.add("fade_in", safe_float_of_string(m["liq_fade_in"]))
    j.add("fade_out", safe_float_of_string(m["liq_fade_out"]))
    if m["liq_cue_in"] != "" then
      j.add("cue_in", safe_float_of_string(m["liq_cue_in"]))
    else
      j.add("cue_in", null())
    end
    if m["liq_cue_out"] != "" then
      j.add("cue_out", safe_float_of_string(m["liq_cue_out"]))  
    else
      j.add("cue_out", null())
    end

    # Convert amplify linear to dB format
    amplify_lin = safe_float_of_string(m["liq_amplify"])
    if amplify_lin > 0. and amplify_lin <= 1. then
      amplify_db = string(dB_of_lin(amplify_lin))
      j.add("amplify", amplify_db)
    end

    # Call API update request function
    artist = m["artist"]
    title = m["title"]
    log(level=2, label="auctocue_azuracast_update", "Autocue data found for #{artist} - #{title}.") 
    autocue_azuracast_update(m["song_id"],json.stringify(j))
  end
end
radio.on_metadata(autocue_update)

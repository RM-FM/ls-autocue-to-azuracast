# ls-autocue-to-azuracast
This Liquidsoap code can be used to store autocue data in Azuracast.

If you aren't aware of the Liquidsoap `autocue` feature yet, please read the **Azuracast Autocue Quickstart Manual** at the bottom of this Read Me.

## What it does
Each time a song starts playing, this script will check if autocue data was determined by Liquidsoap `autocue`. If so, it will update below listed data of the related song/track in Azuracast. You can see the result on Media "Visual Cue Editor" or "Advanced" tab.

- cue in (`liq_cue_in`)
- cue out (`liq_cue_in`)
- crossfade/overlap duration (`liq_cross_duration`)
- fade in (`liq_fade_in`)
- fade out (`liq_fade_in`)
- amplify (`liq_amplify`)

## How to add to Azuracast

### 1. Create API Key
Create a new API Key in Azuracast.

- Navigate to: `My Account > API Keys > Add API Key`
- Choose any name for the new key (e.g. `autocue`) and press "Create new key"
- Copy the API Key and store it in a safe place

### 2. Add script to Azuracast
Copy the content of `liquidsoap.liq` to the 3rd Azuracast Liquisoap Config Box (after `crossfade` / `cross`).

### 3. Add API key to script
Replace `add-your-azuracast-api-key-here` with your API key.

# Azuracast Autocue Quickstart Manual
Proceed with below steps first, if you haven't enabled the **autocue** feature yet. 

**Autocue support starts with Azuracast Rolling Release 2024-04-02.**

1. Disable Azuracast managed crossfading
3. Add to 1st Liquidsoap Config Box: `enable_autocue_metadata()`
4. Add to 3rd Liquidsoap Config Box: `radio = crossfade(radio)`
5. Save & reload station

Unless you know exactly what you are doing, please remove all other custom LS code from the Azuracast config boxes!

Happy autocue-enabled broadcasting!

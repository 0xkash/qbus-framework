/* Need Help? Join my discord @ discord.gg/yWddFpQ */
var config = {
    /* In milliseconds */
    "transitionInterval": 1250,
    "imgInterval": 8000,
    "music": false,
    /* Insert the Youtube Video ID below */
    "videoID": "jo4-FhqkNwQ",
    /* Music Volume (0%-100%) | Lower is Quieter, Higher is Louder */
    "musicVolume": 5,
    "text": {
        "title": "",
        "link": "",
    },
    /* You dont have to include the '/imgs/' dir AND ALSO REMEMBER TO ADD THESE IMGS IN YOUR __resource.lua*/ 
    "images": ['bg0.png', 'bg1.png', 'bg2.png', 'bg3.png', 'bg4.png', 'bg5.png', 'bg6.png', 'bg7.png'],
	
	progressBars:
    {
        "INIT_CORE": {
            enabled: false, //NOTE: Disabled because INIT_CORE seems to not get called properly. (race condition).
        },

        "INIT_BEFORE_MAP_LOADED": {
            enabled: true,
        },

        "MAP": {
            enabled: true,
        },

        "INIT_AFTER_MAP_LOADED": {
            enabled: true,
        },

        "INIT_SESSION": {
            enabled: true,
        }
    },
}

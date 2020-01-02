Config = Config or {}

Config.RepeatTimeout = 2000
Config.CallRepeats = 10
Config.OpenPhone = 244
Config.PhoneApplications = {
    ["phone"] = {
        app = "phone",
        color = "#04b543",
        icon = "fa fa-phone-alt",
        tooltipText = "Telefoon",
        tooltipPos = "top",
        slot = 1,
        Alerts = 0,
    },
    ["whatsapp"] = {
        app = "whatsapp",
        color = "#25d366",
        icon = "fab fa-whatsapp",
        tooltipText = "Whatsapp",
        tooltipPos = "top",
        style = "font-size: 2.8vh";
        slot = 2,
        Alerts = 0,
    },
    ["settings"] = {
        app = "settings",
        color = "#636e72",
        icon = "fa fa-cog",
        tooltipText = "Instellingen",
        tooltipPos = "top",
        style = "padding-right: .08vh; font-size: 2.3vh";
        slot = 3,
        Alerts = 0,
    },
    ["twitter"] = {
        app = "twitter",
        color = "#1da1f2",
        icon = "fab fa-twitter",
        tooltipText = "Twitter",
        tooltipPos = "top",
        slot = 4,
        Alerts = 0,
    },
    ["garage"] = {
        app = "garage",
        color = "#ff8f1a",
        icon = "fas fa-warehouse",
        tooltipText = "Voertuigen",
        slot = 5,
        Alerts = 0,
    },
    ["mails"] = {
        app = "mails",
        color = "#ff002f",
        icon = "fas fa-envelope",
        tooltipText = "Mail",
        slot = 6,
        Alerts = 0,
    },
    ["advert"] = {
        app = "advert",
        color = "#ff8f1a",
        icon = "fas fa-ad",
        tooltipText = "Advertenties",
        slot = 7,
        Alerts = 0,
    },
    ["police"] = {
        app = "police",
        color = "#004682",
        icon = "fas fa-ad",
        tooltipText = "MEOS",
        job = "police",
        slot = 8,
        Alerts = 0,
    },
    ["bank"] = {
        app = "bank",
        color = "#9c88ff",
        icon = "fas fa-university",
        tooltipText = "Bank",
        slot = 9,
        Alerts = 0,
    },
}
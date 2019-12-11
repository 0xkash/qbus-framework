Config = {}

Config.RestrictedChannels = 10 -- channels that are encrypted (EMS, Fire and police can be included there) if we give eg 10, channels from 1 - 10 will be encrypted

Config.MaxFrequency = 500

Config.messages = {
  ['not_on_radio'] = 'Je bent niet verbonden op een signaal',
  ['on_radio'] = 'Je bent al verbonden op dit signaal: <b>',
  ['joined_to_radio'] = 'Je bent verbonden op: <b>',
  ['restricted_channel_error'] = 'Je kan geen verbinding maken met dit signaal!',
  ['you_on_radio'] = 'Je bent al verbonden op dit signaal: <b>',
  ['you_leave'] = 'Je hebt het signaal verlaten: <b>'
}
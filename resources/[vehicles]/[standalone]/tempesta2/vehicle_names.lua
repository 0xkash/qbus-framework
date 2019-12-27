function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
	AddTextEntry("0x0AC758A4", "6STR Carbon Ducktail and Slats")
	AddTextEntry("0x3C563BC1", "6STR Painted Ducktail and Slats")
	AddTextEntry("0x8C59A9DD", "6STR Pegassi Tempesta Custom")
	AddTextEntry("0x327CFF7C", "6STR Exhaust System Chrome Tip")
	AddTextEntry("0x567A81FB", "6STR FattyNappy Splitter")
	AddTextEntry("0x8391C046", "6STR Chassis Mounted Wing")
	AddTextEntry("0xB169E095", "6STR FattyNappy Side Skirt")
	AddTextEntry("0xE729E8D7", "6STR Exhaust System Burnt Tip")
end)
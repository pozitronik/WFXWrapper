unit Settings;

interface

uses IniFiles, System.Variants, Windows;

type

	TSettings = record
		PluginFile: WideString;
	end;

function GetSettings(IniFilePath: WideString): TSettings;
procedure SetSettingsValue(IniFilePath: WideString; OptionName: WideString; OptionValue: Variant);

implementation

function GetSettings(IniFilePath: WideString): TSettings;
var
	IniFile: TIniFile;
begin
	IniFile := TIniFile.Create(IniFilePath);
	GetSettings.PluginFile := IniFile.ReadString('Main', 'PluginFile', '');
	IniFile.Destroy;
end;

procedure SetSettingsValue(IniFilePath: WideString; OptionName: WideString; OptionValue: Variant);
var
	IniFile: TIniFile;
	basicType: Integer;
begin
	IniFile := TIniFile.Create(IniFilePath);

	basicType := VarType(OptionValue);
	try
		case basicType of
			varNull: IniFile.DeleteKey('Main', OptionName); //remove value in that case
			varInteger: IniFile.WriteInteger('Main', OptionName, OptionValue);
			varString, varUString: IniFile.WriteString('Main', OptionName, OptionValue);
			varBoolean: IniFile.WriteBool('Main', OptionName, OptionValue);
		end;
	except
		On E: EIniFileException do
		begin
			MessageBoxW(0, PWideChar(E.Message), 'INI file error', MB_ICONERROR + MB_OK);
			IniFile.Destroy;
			exit;
		end;
	end;
	IniFile.Destroy;
end;

end.

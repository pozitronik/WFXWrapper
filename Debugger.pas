unit Debugger;

interface

uses
	Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ValEdit, Vcl.ExtCtrls, Vcl.Grids, Vcl.StdCtrls, Vcl.Menus, WFXInterface, Plugin_types, Settings;

type
	TTOTAL_CMD = class(TForm)
		MainSplitter: TSplitter;
		FileList: TListBox;
		MainMenu: TMainMenu;
		StartItem: TMenuItem;
		DebugPanel: TListBox;
		LoadItem: TMenuItem;
		LoadPluginDialog: TOpenDialog;
		procedure StartItemClick(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure LoadItemClick(Sender: TObject);
	private
		SettingsIniFilePath: WideString;
		{Private declarations}
	public
		{Public declarations}
		Procedure LoadPlugin(FileName: WideString);
		Procedure AddFindDataToFileList(FileList: TListBox; FindData: tWIN32FINDDATA);

	end;

var
	TOTAL_CMD: TTOTAL_CMD;
	WFX: TWFX;

implementation

{$R *.dfm}

procedure LogProc(PluginNr, MsgType: integer; LogString: pWideChar); stdcall;
begin
	TOTAL_CMD.DebugPanel.AddItem(WFX.MsgCodeToText(MsgType) + ': ' + LogString, nil);
end;

procedure TTOTAL_CMD.AddFindDataToFileList(FileList: TListBox; FindData: tWIN32FINDDATA);
begin
	FileList.Items.Append(FindData.cFileName + (FindData.nFileSizeHigh * MAXDWORD + FindData.nFileSizeLow).ToString);
end;

procedure TTOTAL_CMD.FormCreate(Sender: TObject);
var
	tmp: pWideChar;
begin
	GetMem(tmp, max_path);
	GetModuleFilename(hInstance, tmp, max_path);
	SettingsIniFilePath := tmp + 'wrapper.ini';
	freemem(tmp);
	if (GetSettings(SettingsIniFilePath).PluginFile <> '') then LoadPlugin(GetSettings(SettingsIniFilePath).PluginFile);
end;

procedure TTOTAL_CMD.LoadItemClick(Sender: TObject);
begin
	if (LoadPluginDialog.Execute() and (FileExists(LoadPluginDialog.FileName))) then
	begin
		SetSettingsValue(SettingsIniFilePath, 'PluginFile', LoadPluginDialog.FileName);
		LoadPlugin(GetSettings(SettingsIniFilePath).PluginFile);
	end;
end;

procedure TTOTAL_CMD.LoadPlugin(FileName: WideString);
begin
	LogProc(0, msgtype_details, pWideChar('Loaded file: ' + FileName));
	self.Caption := 'Loaded: ' + FileName;
end;

procedure TTOTAL_CMD.StartItemClick(Sender: TObject);
var
	FindData: tWIN32FINDDATA;
	Handle: THandle;
begin
	WFX:=TWFX.create(GetSettings(SettingsIniFilePath).PluginFile, nil, @LogProc);
	WFX.FsInit(0, nil, @LogProc, nil);
	Handle:=WFX.FindFirstW('\', FindData);
	AddFindDataToFileList(self.FileList, FindData);
	while WFX.FindNextW(Handle, FindData) do
	begin
		Application.ProcessMessages;
		AddFindDataToFileList(self.FileList, FindData);
	end;
	WFX.FindClose(Handle);
end;

end.

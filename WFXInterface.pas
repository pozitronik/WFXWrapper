unit WFXInterface;

interface

Uses
	Windows, SysUtils, Messages, PLUGIN_TYPES;

type

	TWFX = class
	private

		PluginFile: PWideChar;
		ExternalProgressProc: TProgressProcW;
		ExternalLogProc: TLogProcW;

		Function LoadPlugin(): hWnd;

	protected
	public

		type
		tRemoteInfo = record
			SizeLow, SizeHigh: longint;
			LastWriteTime: TFileTime;
			Attr: longint;
		end;

		pRemoteInfo = ^tRemoteInfo;

		tFsDefaultParamStruct = record
			size, PluginInterfaceVersionLow, PluginInterfaceVersionHi: longint;
			DefaultIniName: array [0 .. MAX_PATH - 1] of char;
		end;

		pFsDefaultParamStruct = ^tFsDefaultParamStruct;

	constructor Create(PluginFile: WideString; ExternalProgressProc: TProgressProcW = nil; ExternalLogProc: TLogProcW = nil);
	destructor Destroy; override;
	{}
	function FsInit(): integer;
	Function FindFirstW(Path: WideString; var Find: tWIN32FINDDATA): THandle;
	Function FindNextW(hdl: THandle; var Find: tWIN32FINDDATA): bool;
	Function FindCloseW(hdl: THandle): integer;
	{Function ExtractCustomIcon(RemoteName: pchar; ExtractFlags: integer; var TheIcon: hicon): integer;
	 Function FsExecuteFile(MainWin: THandle; RemoteName, Verb: pchar): integer;
	 Function GetDefRootName(FileName: String): String;
	 Function FsSetAttr(RemoteName: pchar; NewAttr: integer): bool;
	 Function FsSetTime(RemoteName: pchar; CreationTime, LastAccessTime, LastWriteTime: PFileTime): bool;}
	end;

implementation

{TWFX}

constructor TWFX.Create(PluginFile: WideString; ExternalProgressProc: TProgressProcW = nil; ExternalLogProc: TLogProcW = nil);
begin
	self.PluginFile:=PWideChar(PluginFile);
	self.ExternalProgressProc:=ExternalProgressProc;
	self.ExternalLogProc:=ExternalLogProc;

end;

destructor TWFX.Destroy;
begin

	inherited;
end;

function TWFX.FindCloseW(hdl: THandle): integer;
begin

end;

function TWFX.FindFirstW(Path: WideString; var Find: tWIN32FINDDATA): THandle;
begin

end;

function TWFX.FindNextW(hdl: THandle; var Find: tWIN32FINDDATA): bool;
begin

end;

function TWFX.FsInit: integer;
begin

end;

function TWFX.LoadPlugin: hWnd;
begin
	result:=GetModuleHandleW(self.PluginFile);
	if result = 0 then result:=LoadLibrary(self.PluginFile);
end;

end.

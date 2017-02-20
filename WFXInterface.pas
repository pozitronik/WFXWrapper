unit WFXInterface;

interface

Uses
	Windows, SysUtils, Messages, PLUGIN_TYPES;

type
	TFsInitW = function(PluginNr: Integer; pProgressProc: tProgressProc; pLogProc: tlogProc; pRequestProc: tRequestProc): Integer; stdcall;
	TFsFindFirstW = function(path: pwidechar; var FindData: tWIN32FINDDATA): thandle; stdcall;
	TFsFindNextW = function(Hdl: thandle; var FindData: tWIN32FINDDATA): bool; stdcall;
	TFsFindCloseW = function(Hdl: thandle): Integer; stdcall;

	TFsExtractCustomIcon = function(RemoteName: pchar; ExtractFlags: Integer; var TheIcon: hicon): Integer; stdcall;
	TFsExecuteFile = Function(MainWin: thandle; RemoteName, Verb: pchar): Integer; stdcall;
	TFsGetDefRootName = procedure(DefRootName: pchar; maxlen: Integer); stdcall;
	TFsSetAttr = function(RemoteName: pchar; NewAttr: Integer): bool; stdcall;
	TFsSetTime = Function(RemoteName: pchar; CreationTime, LastAccessTime, LastWriteTime: PFileTime): bool; stdcall;

	TWFX = class
	private

		PluginFile: WideString;
		PluginHandle: HWND;

		ExternalProgressProc: TProgressProcW;
		ExternalLogProc: TLogProcW;

		function LoadPlugin(): HWND;
		procedure Log(MsgType: Integer; LogString: WideString);

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
	function FsInit(PluginNr: Integer; pProgressProc: tProgressProc; pLogProc: tlogProc; pRequestProc: tRequestProc): Integer;
	Function FindFirstW(path: WideString; var Find: tWIN32FINDDATA): thandle;
	Function FindNextW(Hdl: thandle; var Find: tWIN32FINDDATA): bool;
	Function FindCloseW(Hdl: thandle): Integer;
	{Function ExtractCustomIcon(RemoteName: pchar; ExtractFlags: integer; var TheIcon: hicon): integer;
	 Function FsExecuteFile(MainWin: THandle; RemoteName, Verb: pchar): integer;
	 Function GetDefRootName(FileName: String): String;
	 Function FsSetAttr(RemoteName: pchar; NewAttr: integer): bool;
	 Function FsSetTime(RemoteName: pchar; CreationTime, LastAccessTime, LastWriteTime: PFileTime): bool;}

	class function MsgCodeToText(MsgCode: Integer): WideString; static;
	end;

implementation

{TWFX}

constructor TWFX.Create(PluginFile: WideString; ExternalProgressProc: TProgressProcW = nil; ExternalLogProc: TLogProcW = nil);
begin
	self.PluginFile:=pwidechar(PluginFile);
	self.ExternalProgressProc:=ExternalProgressProc;
	self.ExternalLogProc:=ExternalLogProc;
	self.PluginHandle:=self.LoadPlugin;
	self.ExternalLogProc(0, msgtype_details, 'Create');
end;

destructor TWFX.Destroy;
begin

	inherited;
end;

function TWFX.FindCloseW(Hdl: thandle): Integer;
begin

end;

function TWFX.FindFirstW(path: WideString; var Find: tWIN32FINDDATA): thandle;
var
	TFFF: TFsFindFirstW;
	tmp: WideString;
begin
	result:=0;
	@TFFF:=GetProcAddress(self.PluginHandle, 'FsFindFirstW');
	if @TFFF = nil then
	begin
		Log(msgtype_importanterror, 'FsFindFirstW not implemented in ' + self.PluginFile);
		//TDebugMessages.AddDebugInfo('FsFindFirst not implemented in ' + Filename, 'ERROR');
		exit;
	end;
	result:=TFFF(pwidechar(path), Find);
	case result of
		INVALID_HANDLE_VALUE:
			begin
				tmp:='INVALID_HANDLE_VALUE';
				Log(msgtype_importanterror, 'INVALID_HANDLE_VALUE' + 'Error #' + inttostr(GetLastError));
			end;
		ERROR_NO_MORE_FILES: tmp:='ERROR_NO_MORE_FILES';
		else tmp:=inttostr(result);
	end;
	//TDebugMessages.AddDebugInfo('FsFindFirst (' + path + ',' + Find.cFileName + ')', tmp);
end;

function TWFX.FindNextW(Hdl: thandle; var Find: tWIN32FINDDATA): bool;
begin

end;

function TWFX.FsInit(PluginNr: Integer; pProgressProc: tProgressProc; pLogProc: tlogProc; pRequestProc: tRequestProc): Integer;
var
	TFIW: TFsInitW;
begin
	@TFIW:=GetProcAddress(self.PluginHandle, 'FsInitW');
	if not Assigned(TFIW) then
	begin
		Log(msgtype_importanterror, 'FsInitW not implemented in ' + self.PluginFile);
		exit;
	end;
	TFIW(PluginNr, pProgressProc, pLogProc, pRequestProc);
end;

function TWFX.LoadPlugin: HWND;
begin
	result:=GetModuleHandleW(pwidechar(self.PluginFile));
	if result = 0 then result:=LoadLibrary(pwidechar(self.PluginFile));
end;

procedure TWFX.Log(MsgType: Integer; LogString: WideString);
begin
	if Assigned(ExternalLogProc) then ExternalLogProc(0, MsgType, pwidechar(LogString));
end;

class function TWFX.MsgCodeToText(MsgCode: Integer): WideString;
begin
	case MsgCode of
		msgtype_connect: exit('msgtype_connect');
		msgtype_disconnect: exit('msgtype_disconnect');
		msgtype_details: exit('msgtype_details');
		msgtype_transfercomplete: exit('msgtype_transfercomplete');
		msgtype_connectcomplete: exit('msgtype_connectcomplete');
		msgtype_importanterror: exit('msgtype_importanterror');
		msgtype_operationcomplete: exit('msgtype_operationcomplete');
		else exit('Code ' + MsgCode.ToString);
	end;
end;

end.

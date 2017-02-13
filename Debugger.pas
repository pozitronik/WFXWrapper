unit Debugger;

interface

uses
	Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ValEdit, Vcl.ExtCtrls, Vcl.Grids, Vcl.StdCtrls;

type
	TTOTAL_CMD = class(TForm)
		MainSplitter: TSplitter;
		DebugPanel: TValueListEditor;
		FileList: TListBox;
	private
		{Private declarations}
	public
		{Public declarations}
	end;

var
	TOTAL_CMD: TTOTAL_CMD;

implementation

{$R *.dfm}

end.

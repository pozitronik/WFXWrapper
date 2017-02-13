program wrapper;

uses
  Vcl.Forms,
  Debugger in 'Debugger.pas' {TOTAL_CMD};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTOTAL_CMD, TOTAL_CMD);
  Application.Run;
end.

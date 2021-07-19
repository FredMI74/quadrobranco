program QuadroBranco;

uses
  Vcl.Forms,
  UnitQuadroBranco in 'UnitQuadroBranco.pas' {FrmQuadroBranco};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmQuadroBranco, FrmQuadroBranco);
  Application.Run;
end.

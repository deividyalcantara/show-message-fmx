unit ShowDialog.RSP.RSP37704;

interface

implementation

uses
  FMX.TextLayout.GPU, FMX.Types;

initialization

finalization
  // https://quality.embarcadero.com/browse/RSP-37704
  TGPUObjectsPool.Uninitialize;

end.

unit uMensagemDlg;

interface

uses
  System.Classes, uMensagemDlgTypes, FMX.Objects, FMX.Types, System.UITypes, FMX.Graphics,
  FMX.Layouts, FMX.StdCtrls, FMX.Forms, SysUtils, FMX.Ani;

type
  TMensagemDlg = class
  private
    FOwner: TFmxObject;
    FTitulo: string;
    FMensagem: string;
    FModeloDialog: TModeloDialogType;
    FBotao: TArrayOfBotao;
    FBotaoEvento: TArrayOfBotaoOnClick;
    FBotaoInverter: TArrayOfBoolean;

    FComponenteLayout: TLayout;
    FComponenteFundo: TRectangle;
    FComponenteBalao: TRectangle;
    FComponenteLayoutIcone: TLayout;
    FComponenteBotao: TRectangle;
    FComponenteTextoBotao: TLabel;
    FComponenteIcone: TPath;
    FComponenteMensagem: TLabel;
    FComponenteTitulo: TLabel;
    FBotoes: TArrayOfWebBotoes;
    FBotaoMargemLateral: Integer;

    FFundoClicarFechar: Boolean;
    FComponenteLayouBotao: TLayout;
    FComponenteAnimacao: TFloatAnimation;
    FComponenteLayoutBotaoFechar: TLayout;
    FComponenteBotaoFechar: TPath;
    FComponenteBotaoFecharEvento: TRectangle;

    procedure PrepararModeloLayout;
    procedure MontarModeloLayout;
    procedure MontarBotoesLayout;

    function Em(base_comparacao: Variant; comparacoes: array of Variant): Boolean;
    function IIf(condicao: Boolean; verdadeiro: variant; Falso: variant): variant;

    procedure SetFundoClicarFechar(const Value: Boolean);

  public
    constructor Create(AOwner: TFmxObject);

    procedure Destruir(Sender: TObject); overload;
    class procedure Destruir; overload;


    class procedure MessageDlg(
      AOwner: TFmxObject;
      titulo: string;
      mensagem: string;
      modelo_dialog: TModeloDialogType;
      botoes: TArrayOfBotao = nil;
      botoes_eventos: TArrayOfBotaoOnClick = nil;
      botoes_inverter: TArrayOfBoolean = nil
    ); overload;

    procedure MessageDlg(
      titulo: string;
      mensagem: string;
      modelo_dialog: TModeloDialogType;
      botoes: TArrayOfBotao = nil;
      botoes_eventos: TArrayOfBotaoOnClick = nil;
      botoes_inverter: TArrayOfBoolean = nil
    ); overload;

    property ComponenteLayout: TLayout read FComponenteLayout write FComponenteLayout;
    property ComponenteFundo: TRectangle read FComponenteFundo write FComponenteFundo;
    property ComponenteBalao: TRectangle read FComponenteBalao write FComponenteBalao;
    property ComponenteLayoutIcone: TLayout read FComponenteLayoutIcone write FComponenteLayoutIcone;
    property ComponenteIcone: TPath read FComponenteIcone write FComponenteIcone;
    property ComponenteBotao: TRectangle read FComponenteBotao write FComponenteBotao;
    property ComponenteTextoBotao: TLabel read FComponenteTextoBotao write FComponenteTextoBotao;
    property ComponenteTitulo: TLabel read FComponenteTitulo write FComponenteTitulo;
    property ComponenteMensagem: TLabel read FComponenteMensagem write FComponenteMensagem;
    property ComponenteLayouBotao: TLayout read FComponenteLayouBotao write FComponenteLayouBotao;
    property ComponenteAnimacao: TFloatAnimation read FComponenteAnimacao write FComponenteAnimacao;
    property ComponenteLayoutBotaoFechar: TLayout read FComponenteLayoutBotaoFechar write FComponenteLayoutBotaoFechar;
    property ComponenteBotaoFecharEvento: TRectangle read FComponenteBotaoFecharEvento write FComponenteBotaoFecharEvento;
    property ComponenteBotaoFechar: TPath read FComponenteBotaoFechar write FComponenteBotaoFechar;

    property FundoClicarFechar: Boolean read FFundoClicarFechar write SetFundoClicarFechar;

  end;

implementation

var
  LMsgDlg: TMensagemDlg;

{ TMensagemDlg }

constructor TMensagemDlg.Create(AOwner: TFmxObject);
begin
  FOwner := AOwner;
end;

class procedure TMensagemDlg.MessageDlg(
  AOwner: TFmxObject;
  titulo: string;
  mensagem: string;
  modelo_dialog: TModeloDialogType;
  botoes: TArrayOfBotao = nil;
  botoes_eventos: TArrayOfBotaoOnClick = nil;
  botoes_inverter: TArrayOfBoolean = nil
);
begin
  if not Assigned(LMsgDlg) then begin
    LMsgDlg := TMensagemDlg.Create(AOwner);
    LMsgDlg.MessageDlg(titulo, mensagem, modelo_dialog, botoes, botoes_eventos, botoes_inverter);
  end;
end;

procedure TMensagemDlg.Destruir(Sender: TObject);
begin
  if Assigned(LMsgDlg) then begin
    LMsgDlg.FComponenteLayout.Free;
    FreeAndNil(LMsgDlg);
  end;
end;

class procedure TMensagemDlg.Destruir;
begin
  if Assigned(LMsgDlg) then begin
    LMsgDlg.FComponenteLayout.Free;
    FreeAndNil(LMsgDlg);
  end;
end;

function TMensagemDlg.Em(base_comparacao: Variant; comparacoes: array of Variant): Boolean;
var
  i: Integer;
begin
  Result := False;

  for i := Low(comparacoes) to High(comparacoes) do begin
    if base_comparacao = comparacoes[i] then begin
      Result:=True;
      Break;
    end;
  end;
end;

function TMensagemDlg.IIf(condicao: Boolean; verdadeiro, Falso: variant): variant;
begin
  if Condicao then
    Result:=Verdadeiro
  else
    Result:=Falso;
end;

procedure TMensagemDlg.MessageDlg(
  titulo: string;
  mensagem: string;
  modelo_dialog: TModeloDialogType;
  botoes: TArrayOfBotao = nil;
  botoes_eventos: TArrayOfBotaoOnClick = nil;
  botoes_inverter: TArrayOfBoolean = nil
);
begin
  FTitulo := titulo;
  FMensagem := mensagem;
  FModeloDialog := modelo_dialog;
  FBotao := botoes;
  FBotaoEvento := botoes_eventos;
  FBotaoInverter := botoes_inverter;

  MontarModeloLayout;
  PrepararModeloLayout;
end;

procedure TMensagemDlg.MontarBotoesLayout;
var
  tamanho_botao: Integer;
  i: Integer;
  posic_atual: Integer;
  nome: string;

  procedure CalcularTamanhoBotao;
  var
    desconto: Double;
  begin
    desconto := ((FBotaoMargemLateral * 2) + (((Length(FBotao)) - 1) * FBotaoMargemLateral));
    tamanho_botao := Round((FComponenteBalao.Width - desconto) / (Length(FBotao)));
  end;
begin
  CalcularTamanhoBotao;

  posic_atual := FBotaoMargemLateral;

  for i := Low(FBotao) to High(FBotao) do begin
    SetLength(FBotoes, Length(FBotoes) + 1);
    FBotoes[High(FBotoes)].botao := TRectangle.Create(FComponenteLayouBotao);
    FBotoes[High(FBotoes)].texto := TLabel.Create(FBotoes[High(FBotoes)].botao);

    nome := StringReplace(cDlgMsg[FBotao[i]], ' ', '', [rfReplaceAll]);
    nome := StringReplace(nome, '!', '', [rfReplaceAll]);

    with FBotoes[High(FBotoes)].botao do begin
      Parent := FComponenteLayouBotao;
      Name := 'btnDlg' + nome;
      Align := TAlignLayout.Scale;
      HitTest := True;
      try
        OnClick := FBotaoEvento[i];
      except

      end;
    end;

    with FBotoes[High(FBotoes)].texto do begin
      Parent := FBotoes[High(FBotoes)].botao;
      Name := 'lblDlg' + nome;
      Text := cDlgMsg[FBotao[i]];
      Align := TAlignLayout.Client;
      HitTest := False;
      StyledSettings := StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size, TStyledSetting.Style];
    end;

    if i = Low(FBotao) then begin
      FBotoes[High(FBotoes)].botao.Margins.Left := FBotaoMargemLateral;
    end
    else if i = High(FBotao) then begin
      FBotoes[High(FBotoes)].botao.Margins.Right := FBotaoMargemLateral;
    end
    else begin
      if (Length(FBotao) - 1 > 1) then
        FBotoes[High(FBotoes)].botao.Margins.Left := FBotaoMargemLateral;
    end;

    FBotoes[High(FBotoes)].botao.Position.X := posic_atual;
    FBotoes[High(FBotoes)].botao.Width := tamanho_botao;

    posic_atual :=
      Round(posic_atual + FBotoes[High(FBotoes)].botao.Margins.Left +  FBotoes[High(FBotoes)].botao.Margins.Right + tamanho_botao);
  end;
end;

procedure TMensagemDlg.MontarModeloLayout;
begin
  FComponenteLayout := TLayout.Create(FOwner);
  FComponenteLayout.Parent := FOwner;
  FComponenteLayout.Align := TAlignLayout.Contents;

  FComponenteAnimacao := TFloatAnimation.Create(FComponenteLayout);
  FComponenteAnimacao.Parent := FComponenteLayout;

  FComponenteFundo := TRectangle.Create(FComponenteLayout);
  FComponenteFundo.Parent := FComponenteLayout;

  FComponenteBalao := TRectangle.Create(FComponenteLayout);
  FComponenteBalao.Parent := FComponenteLayout;

  FComponenteLayoutBotaoFechar := TLayout.Create(FComponenteBalao);
  FComponenteLayoutBotaoFechar.Parent := FComponenteBalao;

  FComponenteBotaoFecharEvento := TRectangle.Create(FComponenteLayoutBotaoFechar);
  FComponenteBotaoFecharEvento.Parent := FComponenteLayoutBotaoFechar;

  FComponenteBotaoFechar := TPath.Create(FComponenteBotaoFecharEvento);
  FComponenteBotaoFechar.Parent := FComponenteBotaoFecharEvento;

  FComponenteLayoutIcone := TLayout.Create(FComponenteBalao);
  FComponenteLayoutIcone.Parent := FComponenteBalao;

  FComponenteIcone := TPath.Create(FComponenteLayoutIcone);
  FComponenteIcone.Parent := FComponenteLayoutIcone;

  FComponenteTitulo := TLabel.Create(FComponenteBalao);
  FComponenteTitulo.Parent := FComponenteBalao;
  FComponenteTitulo.Text := FTitulo;
  FComponenteTitulo.StyledSettings := FComponenteTitulo.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size, TStyledSetting.Style];

  FComponenteMensagem := TLabel.Create(FComponenteBalao);
  FComponenteMensagem.Parent := FComponenteBalao;
  FComponenteMensagem.Text := FMensagem;
  FComponenteMensagem.StyledSettings := FComponenteMensagem.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size, TStyledSetting.Style];

  FComponenteLayouBotao := TLayout.Create(FComponenteBalao);
  FComponenteLayouBotao.Parent := FComponenteBalao;
  FComponenteLayouBotao.Align := TAlignLayout.Bottom;

  FFundoClicarFechar := False;
end;

procedure TMensagemDlg.PrepararModeloLayout;
var
  i: Integer;
  inveter_estilo_botao: Boolean;
  cor_label: TAlphaColor;
begin
  FComponenteLayout.Opacity := 0;

  FComponenteAnimacao.Duration := 0.2;
  FComponenteAnimacao.PropertyName := 'Opacity';
  FComponenteAnimacao.StartValue := 0;
  FComponenteAnimacao.StopValue := 1;

  if Em(FModeloDialog, [TModeloDialogType.mdModelo1Aviso, TModeloDialogType.mdModelo1Erro, TModeloDialogType.mdModelo1Informacao, TModeloDialogType.mdModelo1Confirmacao, TModeloDialogType.mdModelo1Questionamento]) then begin
    FComponenteLayoutBotaoFechar.Visible := False;

    FComponenteFundo.Fill.Color := cCorPreta;
    FComponenteFundo.Stroke.Kind := TBrushKind.None;
    FComponenteFundo.Opacity := 0.2;
    FComponenteFundo.Align := TAlignLayout.Client;

    FComponenteBalao.Align := TAlignLayout.Client;
    FComponenteBalao.Fill.Color := cCorBranca;
    FComponenteBalao.XRadius := 8;
    FComponenteBalao.YRadius := 8;
    FComponenteBalao.Margins.Left := 10;
    FComponenteBalao.Margins.Right := 10;
    FComponenteBalao.Margins.Top := 10;
    FComponenteBalao.Margins.Bottom := 10;
    FComponenteBalao.Stroke.Kind := TBrushKind.None;
    FComponenteBalao.BringToFront;

    FComponenteTitulo.Margins.Left := 10;
    FComponenteTitulo.Margins.Right := 10;
    FComponenteTitulo.Margins.Top := 20;
    FComponenteTitulo.Height := 30;
    FComponenteTitulo.Font.Size := 24;
    FComponenteTitulo.TextSettings.HorzAlign := TTextAlign.Center;
    case FModeloDialog of
      mdModelo1Aviso: FComponenteTitulo.TextSettings.FontColor := $FFECAF4E;
      mdModelo1Erro: FComponenteTitulo.TextSettings.FontColor := $FFF77275;
      mdModelo1Informacao: FComponenteTitulo.TextSettings.FontColor := $FF4ABDFE;
      mdModelo1Confirmacao: FComponenteTitulo.TextSettings.FontColor := $FF44BB5B;
      mdModelo1Questionamento: FComponenteTitulo.TextSettings.FontColor := $FF4A96FE;
    end;
    FComponenteTitulo.Font.Style := FComponenteTitulo.TextSettings.Font.Style + [TFontStyle.fsBold];
    FComponenteTitulo.TabOrder := 2;

    FComponenteMensagem.Margins.Left := 20;
    FComponenteMensagem.Margins.Right := 20;
    FComponenteMensagem.Margins.Top := 10;
    FComponenteMensagem.Font.Size := 18;
    FComponenteMensagem.TextSettings.HorzAlign := TTextAlign.Center;
    FComponenteMensagem.TextSettings.FontColor := $FF72777B;
    FComponenteMensagem.TextSettings.VertAlign := TTextAlign.Leading;
    FComponenteMensagem.TextSettings.WordWrap := True;
    FComponenteMensagem.TextSettings.Trimming := TTextTrimming.Word;
    FComponenteMensagem.AutoSize := True;

    FComponenteLayoutIcone.Height := 120;
    FComponenteLayoutIcone.Margins.Top := 30;

    FComponenteIcone.Align := TAlignLayout.HorzCenter;
    FComponenteIcone.Width := FComponenteLayoutIcone.Height;
    case FModeloDialog of
      mdModelo1Aviso: FComponenteIcone.Fill.Color := $FFECAF4E;
      mdModelo1Erro: FComponenteIcone.Fill.Color := $FFF77275;
      mdModelo1Informacao: FComponenteIcone.Fill.Color := $FF4ABDFE;
      mdModelo1Confirmacao: FComponenteIcone.Fill.Color := $FF44BB5B;
      mdModelo1Questionamento: FComponenteIcone.Fill.Color := $FF4A96FE;
    end;
    FComponenteIcone.Stroke.Kind := TBrushKind.None;
    FComponenteIcone.Data.Data := cDlgImg[FModeloDialog];

    FComponenteLayouBotao.Margins.Bottom := 30;
    FComponenteLayouBotao.Height := 48;

    FBotaoMargemLateral := 30;
    MontarBotoesLayout;

    for i := Low(FBotoes) to High(FBotoes) do begin
      with FBotoes[i].botao do begin
        case FModeloDialog of
          mdModelo1Aviso: Fill.Color := $FFECAF4E;
          mdModelo1Erro: Fill.Color := $FFF77275;
          mdModelo1Informacao: Fill.Color := $FF4ABDFE;
          mdModelo1Confirmacao: Fill.Color := $FF44BB5B;
          mdModelo1Questionamento: Fill.Color := $FF4A96FE;
        end;
        Stroke.Kind := TBrushKind.None;
        XRadius := 8;
        Height := FComponenteLayouBotao.Height;
        Position.Y := 0;
        YRadius := 8;
      end;

      with FBotoes[i].texto do begin
        TextSettings.FontColor := cCorBranca;
        TextSettings.HorzAlign := TTextAlign.Center;
        TextSettings.VertAlign := TTextAlign.Center;
        Font.Size := 18;
      end;
    end;

    FComponenteMensagem.Align := TAlignLayout.Client;
    FComponenteTitulo.Align := TAlignLayout.Top;
    FComponenteLayoutIcone.Align := TAlignLayout.Top;
  end
  else if Em(FModeloDialog, [TModeloDialogType.mdModelo3Sucesso, TModeloDialogType.mdModelo3Erro]) then begin
    FComponenteFundo.Fill.Color := cCorPreta;
    FComponenteFundo.Stroke.Kind := TBrushKind.None;
    FComponenteFundo.Opacity := 0.2;
    FComponenteFundo.Align := TAlignLayout.Client;

    FComponenteBalao.Align := TAlignLayout.Client;
    FComponenteBalao.Fill.Color := IIf(FModeloDialog = mdModelo3Sucesso, cCorBranca, $FFE35547);
    FComponenteBalao.Stroke.Color := IIf(FModeloDialog = mdModelo3Sucesso, cCorBranca, $FFE35547);
    FComponenteBalao.XRadius := 8;
    FComponenteBalao.YRadius := 8;
    FComponenteBalao.Margins.Left := 10;
    FComponenteBalao.Margins.Right := 10;
    FComponenteBalao.Margins.Top := 10;
    FComponenteBalao.Margins.Bottom := 10;
    FComponenteBalao.BringToFront;

    FComponenteLayoutBotaoFechar.Margins.Top := 10;
    FComponenteLayoutBotaoFechar.Margins.Right := 10;
    FComponenteLayoutBotaoFechar.Height := 17;
    FComponenteLayoutBotaoFechar.HitTest := False;

    FComponenteBotaoFecharEvento.Width := 17;
    FComponenteBotaoFecharEvento.Stroke.Kind := TBrushKind.None;
    FComponenteBotaoFecharEvento.Fill.Color := $00FFFFFF;
    FComponenteBotaoFecharEvento.Align := TAlignLayout.Right;
    FComponenteBotaoFecharEvento.OnClick := Destruir;

    FComponenteBotaoFechar.Data.Data := cIconeFechar;
    FComponenteBotaoFechar.Align := TAlignLayout.Client;
    FComponenteBotaoFechar.Fill.Color := IIf(FModeloDialog = mdModelo3Sucesso, $FFD2D2D2, cCorBranca);
    FComponenteBotaoFechar.Stroke.Kind := TBrushKind.None;
    FComponenteBotaoFechar.HitTest := False;

    FComponenteTitulo.Margins.Left := 10;
    FComponenteTitulo.Margins.Right := 10;
    FComponenteTitulo.Margins.Top := 20;
    FComponenteTitulo.Height := 45;
    FComponenteTitulo.Font.Size := 33;
    FComponenteTitulo.TextSettings.HorzAlign := TTextAlign.Center;
    FComponenteTitulo.TextSettings.FontColor := IIf(FModeloDialog = mdModelo3Sucesso, $FF2C2C2C, cCorBranca);
    FComponenteTitulo.Font.Style := FComponenteTitulo.TextSettings.Font.Style + [TFontStyle.fsBold];

    FComponenteMensagem.Margins.Left := 10;
    FComponenteMensagem.Margins.Right := 10;
    FComponenteMensagem.Margins.Top := 10;
    FComponenteMensagem.Font.Size := 20;
    FComponenteMensagem.Height := 27;
    FComponenteMensagem.TextSettings.HorzAlign := TTextAlign.Center;
    FComponenteMensagem.TextSettings.FontColor := IIf(FModeloDialog = mdModelo3Sucesso, $FF6D6D6D, cCorBranca);
    FComponenteMensagem.TextSettings.VertAlign := TTextAlign.Leading;
    FComponenteMensagem.TextSettings.WordWrap := True;
    FComponenteMensagem.TextSettings.Trimming := TTextTrimming.Word;
    FComponenteMensagem.AutoSize := True;

    FComponenteLayoutIcone.Align := TAlignLayout.VertCenter;
    FComponenteLayoutIcone.Height := 120;

    FComponenteIcone.Align := TAlignLayout.HorzCenter;
    FComponenteIcone.Width := FComponenteLayoutIcone.Height;
    FComponenteIcone.Fill.Color := IIf(FModeloDialog = mdModelo3Sucesso, $FF34BD25, cCorBranca);
    FComponenteIcone.Stroke.Kind := TBrushKind.None;
    FComponenteIcone.Data.Data := cDlgImg[FModeloDialog];

    FComponenteLayouBotao.Margins.Bottom := 30;
    FComponenteLayouBotao.Height := 48;

    FBotaoMargemLateral := 30;
    MontarBotoesLayout;

    for i := Low(FBotoes) to High(FBotoes) do begin
      with FBotoes[i].botao do begin
        Fill.Color := IIf(FModeloDialog = mdModelo3Sucesso, $FF34BD25, $FFA5362D);
        Stroke.Kind := TBrushKind.None;
        XRadius := 20;
        YRadius := 20;
        Height := FComponenteLayouBotao.Height;
        Position.Y := 0;
      end;

      with FBotoes[i].texto do begin
        TextSettings.FontColor := cCorBranca;
        TextSettings.HorzAlign := TTextAlign.Center;
        TextSettings.VertAlign := TTextAlign.Center;
        Font.Style := TextSettings.Font.Style + [TFontStyle.fsBold];
        Font.Size := 20;
      end;
    end;

    FComponenteMensagem.Align := TAlignLayout.Top;
    FComponenteTitulo.Align := TAlignLayout.Top;
    FComponenteLayoutBotaoFechar.Align := TAlignLayout.Top;
  end
  else if Em(FModeloDialog, [TModeloDialogType.mdModelo2Sucesso, TModeloDialogType.mdModelo2Erro]) then begin
    FComponenteLayoutBotaoFechar.Visible := False;

    FComponenteFundo.Fill.Color := cCorPreta;
    FComponenteFundo.Stroke.Kind := TBrushKind.None;
    FComponenteFundo.Opacity := 0.2;
    FComponenteFundo.Align := TAlignLayout.Client;

    FComponenteBalao.Align := TAlignLayout.VertCenter;
    FComponenteBalao.Fill.Color := IIf(FModeloDialog = mdModelo2Sucesso, $FF00C853, $FFD50000);
    FComponenteBalao.Stroke.Color := IIf(FModeloDialog = mdModelo2Sucesso, $FF4AB201, $FFB60000);
    FComponenteBalao.XRadius := 20;
    FComponenteBalao.YRadius := 20;
    FComponenteBalao.Height := 300;
    FComponenteBalao.BringToFront;
    FComponenteBalao.Margins.Left := 10;
    FComponenteBalao.Margins.Right := 10;

    FComponenteLayoutIcone.Height := 90;
    FComponenteLayoutIcone.Margins.Top := 20;

    FComponenteIcone.Align := TAlignLayout.HorzCenter;
    FComponenteIcone.Width := 90;
    FComponenteIcone.Fill.Color := cCorBranca;
    FComponenteIcone.Stroke.Kind := TBrushKind.None;
    FComponenteIcone.RotationAngle := 180;
    FComponenteIcone.Data.Data := cDlgImg[FModeloDialog];

    FComponenteTitulo.Margins.Left := 10;
    FComponenteTitulo.Margins.Right := 10;
    FComponenteTitulo.Margins.Top := 20;
    FComponenteTitulo.Font.Size := 18;
    FComponenteTitulo.TextSettings.HorzAlign := TTextAlign.Center;
    FComponenteTitulo.TextSettings.FontColor := cCorBranca;
    FComponenteTitulo.Font.Style := FComponenteTitulo.TextSettings.Font.Style + [TFontStyle.fsBold];

    FComponenteMensagem.Margins.Left := 10;
    FComponenteMensagem.Margins.Right := 10;
    FComponenteMensagem.Margins.Top := 10;
    FComponenteMensagem.Font.Size := 16;
    FComponenteMensagem.Height := 16;
    FComponenteMensagem.TextSettings.HorzAlign := TTextAlign.Center;
    FComponenteMensagem.TextSettings.FontColor := cCorBranca;
    FComponenteMensagem.TextSettings.VertAlign := TTextAlign.Leading;

    FComponenteLayouBotao.Margins.Bottom := 10;
    FComponenteLayouBotao.Height := 48;

    FBotaoMargemLateral := 10;

    MontarBotoesLayout;

    for i := Low(FBotoes) to High(FBotoes) do begin
      with FBotoes[i].botao do begin
        Fill.Color := cCorBranca;
        Stroke.Kind := TBrushKind.None;
        XRadius := 20;
        YRadius := 20;
        Height := FComponenteLayouBotao.Height;
        Position.Y := 0;
      end;

      with FBotoes[i].texto do begin
        TextSettings.FontColor :=IIf(FModeloDialog = mdModelo2Sucesso, $FF00C853, $FFD50000);
        TextSettings.HorzAlign := TTextAlign.Center;
        TextSettings.VertAlign := TTextAlign.Center;
        Text := UpperCase(Text);
      end;
    end;

    FComponenteMensagem.Align := TAlignLayout.Client;
    FComponenteTitulo.Align := TAlignLayout.Top;
    FComponenteLayoutIcone.Align := TAlignLayout.Top;
  end;


  for i := Low(FBotoes) to High(FBotoes) do begin
    try
      inveter_estilo_botao := FBotaoInverter[i];
    except
      inveter_estilo_botao := False;
    end;

    if inveter_estilo_botao then begin
      FBotoes[i].botao.Stroke.Kind := TBrushKind.Solid;
      FBotoes[i].botao.Stroke.Thickness := 3;
      FBotoes[i].botao.Stroke.Color := FBotoes[i].botao.Fill.Color;

      cor_label := FBotoes[i].texto.FontColor;
      FBotoes[i].texto.FontColor := FBotoes[i].botao.Fill.Color;

      FBotoes[i].botao.Fill.Color := cor_label;
    end;
  end;

  FComponenteAnimacao.Start;

  if FFundoClicarFechar then
    FComponenteFundo.OnClick := Destruir;
end;


procedure TMensagemDlg.SetFundoClicarFechar(const Value: Boolean);
begin
  FFundoClicarFechar := Value;
end;

end.



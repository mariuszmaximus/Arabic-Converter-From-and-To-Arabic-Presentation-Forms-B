unit ArabicConverter;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;


function convertArabic(normal: WideString):WideString;

implementation


type
  CharRep = record
    code:widechar;
    mIsolated:widechar;
    mInitial:widechar;
    mMedial:widechar;
    mFinal:widechar;
  end;

  CombCharRep = record
    code: array[0..1] of widechar;
    mIsolated:widechar;
    mInitial:widechar;
    mMedial:widechar;
    mFinal:widechar;
  end;

const
  MAP_LENGTH = 37;
  COMB_MAP_LENGTH = 4;
  TRANS_CHARS_LENGTH = 39;

const NIC = #$0;

var
  charsMap:array[0..MAP_LENGTH-1] of CharRep = (
  ( code:#$0621; mIsolated:#$FE80; mInitial:NIC;    mMedial:NIC;    mFinal:NIC ), // HAMZA */
  ( code:#$0622; mIsolated:#$FE81; mInitial:NIC;    mMedial:NIC;    mFinal:#$FE82 ), // ALEF_MADDA */
  ( code:#$0623; mIsolated:#$FE83; mInitial:NIC;    mMedial:NIC;    mFinal:#$FE84 ), // ALEF_HAMZA_ABOVE */
  ( code:#$0624; mIsolated:#$FE85; mInitial:NIC;    mMedial:NIC;    mFinal:#$FE86 ), // WAW_HAMZA */
  ( code:#$0625; mIsolated:#$FE87; mInitial:NIC;    mMedial:NIC;    mFinal:#$FE88 ), // ALEF_HAMZA_BELOW */
  ( code:#$0626; mIsolated:#$FE89; mInitial:#$FE8B; mMedial:#$FE8C; mFinal:#$FE8A ), // YEH_HAMZA */
  ( code:#$0627; mIsolated:#$FE8D; mInitial:NIC;    mMedial:NIC;    mFinal:#$FE8E ), // ALEF */
  ( code:#$0628; mIsolated:#$FE8F; mInitial:#$FE91; mMedial:#$FE92; mFinal:#$FE90 ), // BEH */
  ( code:#$0629; mIsolated:#$FE93; mInitial:NIC;    mMedial:NIC;    mFinal:#$FE94 ), // TEH_MARBUTA */
  ( code:#$062A; mIsolated:#$FE95; mInitial:#$FE97; mMedial:#$FE98; mFinal:#$FE96 ), // TEH */
  ( code:#$062B; mIsolated:#$FE99; mInitial:#$FE9B; mMedial:#$FE9C; mFinal:#$FE9A ), // THEH */
  ( code:#$062C; mIsolated:#$FE9D; mInitial:#$FE9F; mMedial:#$FEA0; mFinal:#$FE9E ), // JEEM */
  ( code:#$062D; mIsolated:#$FEA1; mInitial:#$FEA3; mMedial:#$FEA4; mFinal:#$FEA2 ), // HAH */
  ( code:#$062E; mIsolated:#$FEA5; mInitial:#$FEA7; mMedial:#$FEA8; mFinal:#$FEA6 ), // KHAH */
  ( code:#$062F; mIsolated:#$FEA9; mInitial:NIC;    mMedial:NIC; mFinal:#$FEAA ), // DAL */
  ( code:#$0630; mIsolated:#$FEAB; mInitial:NIC;    mMedial:NIC; mFinal:#$FEAC ), // THAL */
  ( code:#$0631; mIsolated:#$FEAD; mInitial:NIC;    mMedial:NIC; mFinal:#$FEAE ), // REH */
  ( code:#$0632; mIsolated:#$FEAF; mInitial:NIC;    mMedial:NIC; mFinal:#$FEB0 ), // ZAIN */
  ( code:#$0633; mIsolated:#$FEB1; mInitial:#$FEB3; mMedial:#$FEB4; mFinal:#$FEB2 ), // SEEN */
  ( code:#$0634; mIsolated:#$FEB5; mInitial:#$FEB7; mMedial:#$FEB8; mFinal:#$FEB6 ), // SHEEN */
  ( code:#$0635; mIsolated:#$FEB9; mInitial:#$FEBB; mMedial:#$FEBC; mFinal:#$FEBA ), // SAD */
  ( code:#$0636; mIsolated:#$FEBD; mInitial:#$FEBF; mMedial:#$FEC0; mFinal:#$FEBE ), // DAD */
  ( code:#$0637; mIsolated:#$FEC1; mInitial:#$FEC3; mMedial:#$FEC4; mFinal:#$FEC2 ), // TAH */
  ( code:#$0638; mIsolated:#$FEC5; mInitial:#$FEC7; mMedial:#$FEC8; mFinal:#$FEC6 ), // ZAH */
  ( code:#$0639; mIsolated:#$FEC9; mInitial:#$FECB; mMedial:#$FECC; mFinal:#$FECA ), // AIN */
  ( code:#$063A; mIsolated:#$FECD; mInitial:#$FECF; mMedial:#$FED0; mFinal:#$FECE ), // GHAIN */
  ( code:#$0640; mIsolated:#$0640; mInitial:NIC;    mMedial:NIC; mFinal:NIC ), // TATWEEL */
  ( code:#$0641; mIsolated:#$FED1; mInitial:#$FED3; mMedial:#$FED4; mFinal:#$FED2 ), // FEH */
  ( code:#$0642; mIsolated:#$FED5; mInitial:#$FED7; mMedial:#$FED8; mFinal:#$FED6 ), // QAF */
  ( code:#$0643; mIsolated:#$FED9; mInitial:#$FEDB; mMedial:#$FEDC; mFinal:#$FEDA ), // KAF */
  ( code:#$0644; mIsolated:#$FEDD; mInitial:#$FEDF; mMedial:#$FEE0; mFinal:#$FEDE ), // LAM */
  ( code:#$0645; mIsolated:#$FEE1; mInitial:#$FEE3; mMedial:#$FEE4; mFinal:#$FEE2 ), // MEEM */
  ( code:#$0646; mIsolated:#$FEE5; mInitial:#$FEE7; mMedial:#$FEE8; mFinal:#$FEE6 ), // NOON */
  ( code:#$0647; mIsolated:#$FEE9; mInitial:#$FEEB; mMedial:#$FEEC; mFinal:#$FEEA ), // HEH */
  ( code:#$0648; mIsolated:#$FEED; mInitial:NIC;    mMedial:NIC; mFinal:#$FEEE ), // WAW */
  //( code:#$0649; mIsolated:#$FEEF; mInitial:#$FBE8; mMedial:#$FBE9; mFinal:#$FEF0 ),    // ALEF_MAKSURA */
  ( code:#$0649; mIsolated:#$FEEF; mInitial:NIC;    mMedial:NIC; mFinal:#$FEF0 ), // ALEF_MAKSURA */
  ( code:#$064A; mIsolated:#$FEF1; mInitial:#$FEF3; mMedial:#$FEF4; mFinal:#$FEF2 ) // YEH */
  );

  combCharsMap:array[0..COMB_MAP_LENGTH-1] of CombCharRep = (
  ( code:( #$0644, #$0622); mIsolated:#$FEF5; mInitial:NIC; mMedial:NIC; mFinal:#$FEF6 ), //* LAM_ALEF_MADDA */
  ( code:( #$0644, #$0623); mIsolated:#$FEF7; mInitial:NIC; mMedial:NIC; mFinal:#$FEF8 ), //* LAM_ALEF_HAMZA_ABOVE */
  ( code:( #$0644, #$0625); mIsolated:#$FEF9; mInitial:NIC; mMedial:NIC; mFinal:#$FEFA ), //* LAM_ALEF_HAMZA_BELOW */
  ( code:( #$0644, #$0627); mIsolated:#$FEFB; mInitial:NIC; mMedial:NIC; mFinal:#$FEFC )  //* LAM_ALEF */
  );

  transChars:array[0..TRANS_CHARS_LENGTH-1] of WideChar = (
	#$0610, //* ARABIC SIGN SALLALLAHOU ALAYHE WASSALLAM */
	#$0612, //* ARABIC SIGN ALAYHE ASSALLAM */
	#$0613, //* ARABIC SIGN RADI ALLAHOU ANHU */
	#$0614, //* ARABIC SIGN TAKHALLUS */
	#$0615, //* ARABIC SMALL HIGH TAH */
	#$064B, //* ARABIC FATHATAN */
	#$064C, //* ARABIC DAMMATAN */
	#$064D, //* ARABIC KASRATAN */
	#$064E, //* ARABIC FATHA */
	#$064F, //* ARABIC DAMMA */
	#$0650, //* ARABIC KASRA */
	#$0651, //* ARABIC SHADDA */
	#$0652, //* ARABIC SUKUN */
	#$0653, //* ARABIC MADDAH ABOVE */
	#$0654, //* ARABIC HAMZA ABOVE */
	#$0655, //* ARABIC HAMZA BELOW */
	#$0656, //* ARABIC SUBSCRIPT ALEF */
	#$0657, //* ARABIC INVERTED DAMMA */
	#$0658, //* ARABIC MARK NOON GHUNNA */
	#$0670, //* ARABIC LETTER SUPERSCRIPT ALEF */
	#$06D6, //* ARABIC SMALL HIGH LIGATURE SAD WITH LAM WITH ALEF MAKSURA */
	#$06D7, //* ARABIC SMALL HIGH LIGATURE QAF WITH LAM WITH ALEF MAKSURA */
	#$06D8, //* ARABIC SMALL HIGH MEEM INITIAL FORM */
	#$06D9, //* ARABIC SMALL HIGH LAM ALEF */
	#$06DA, //* ARABIC SMALL HIGH JEEM */
	#$06DB, //* ARABIC SMALL HIGH THREE DOTS */
	#$06DC, //* ARABIC SMALL HIGH SEEN */
	#$06DF, //* ARABIC SMALL HIGH ROUNDED ZERO */
	#$06E0, //* ARABIC SMALL HIGH UPRIGHT RECTANGULAR ZERO */
	#$06E1, //* ARABIC SMALL HIGH DOTLESS HEAD OF KHAH */
	#$06E2, //* ARABIC SMALL HIGH MEEM ISOLATED FORM */
	#$06E3, //* ARABIC SMALL LOW SEEN */
	#$06E4, //* ARABIC SMALL HIGH MADDA */
	#$06E7, //* ARABIC SMALL HIGH YEH */
	#$06E8, //* ARABIC SMALL HIGH NOON */
	#$06EA, //* ARABIC EMPTY CENTRE LOW STOP */
	#$06EB, //* ARABIC EMPTY CENTRE HIGH STOP */
	#$06EC, //* ARABIC ROUNDED HIGH STOP WITH FILLED CENTRE */
	#$06ED  //* ARABIC SMALL LOW MEEM */
  );


function CharacterMapContains(c: widechar): boolean;
var
  i: integer;
begin
  result := false;
  for i :=0 to MAP_LENGTH -1 do
  begin
    if (charsMap[i].code = c) then
    begin
      result := true;
      exit;
    end;
  end;
end;

function GetCharRep(c: widechar): CharRep;
var
  i:integer;
begin
  for i := 0 to MAP_LENGTH -1 do
  begin
    if (charsMap[i].code = c) then
    begin
      result := charsMap[i];
      exit;
    end;
  end;

  result.code:=NIC;
  result.mFinal:=NIC;
  result.mInitial:=NIC;
  result.mIsolated:=NIC;
  result.mMedial:=NIC;
end;

function GetCombCharRep(c1,c2: widechar): CombCharRep;
var
  i: integer;
begin
  for i:=0 to COMB_MAP_LENGTH -1 do
  begin
     if (combCharsMap[i].code[0] = c1) AND (combCharsMap[i].code[1] = c2) then
     begin
        result :=  combCharsMap[i];
        exit;
     end;
  end;

  result.code[0]:=NIC;
  result.code[1]:=NIC;
  result.mIsolated:=NIC;
  result.mInitial:=NIC;
  result.mMedial:=NIC;
  result.mFinal:=NIC;
end;

function IsTransparent(c: widechar): boolean;
var
  i:integer;
begin
  for i:= 0 to TRANS_CHARS_LENGTH -1 do
  begin
     if (transChars[i] = c) then
     begin
       result := true;
       exit;
     end;
  end;
  result := false;
end;

function convertArabic(normal: WideString):WideString;
var
  len: integer;
  i: integer;
  current: wchar;
  prev: wchar;
  next: wchar;
  prevID , nextID : integer;
  tmp: integer;
  crep: CharRep;
  combcrep: CombCharRep;
  shaped: WideString;
  writeCount: integer;
begin
  shaped := normal;
  writeCount := 1;
  len := length(normal);

  i := 1;
  while i <= len do
  begin
    current  := normal[i];
    if (CharacterMapContains(current)) then
    begin
      prev := NIC;
      next := NIC;
      prevID := i - 1;
      nextID := 1 + 1;

      //for (; prevID >= 0; prevID--)
      //    if (!IsTransparent([normal characterAtIndex:prevID]))
      //        break;      for tmp := prevID downto 1 do
      for tmp := prevID downto 1 do
      begin
        if not IsTransparent(normal[tmp]) then
        begin
          prevID  := tmp;
          break;
        end;
      end;


      //if ((prevID < 0) || !CharacterMapContains(prev = [normal characterAtIndex:prevID])
      //    || (!((crep = GetCharRep(prev)).mInitial != NIL) && !(crep.mMedial != NIL)))
      //    prev = NIL;
      prev := normal[prevID];
      crep := GetCharRep(prev);
      if ((prevID < 1) OR NOT CharacterMapContains(prev)
                     OR (NOT (crep .mInitial <> NIC) AND NOT(crep.mMedial <> NIC)))
      then
        prev := NIC;


      ///* Combinations */
      if ((current = #$0644) AND (next <> NIC) AND ((next = #$0622) OR (next = #$0623)
                                               OR (next = #$0625) OR (next = #$0627))) then
      begin
          combcrep := GetCombCharRep(current, next);
          if (prev <> NIC) then
          begin
              shaped[writeCount] := combcrep.mFinal; inc(writeCount);
          end
          else
          begin
              shaped[writeCount] := combcrep.mIsolated; inc(writeCount);
          end;
          inc(i);//i++;
          inc(i); continue;
      end;

      crep := GetCharRep(current);

      //* Medial */
      if ((prev <> NIC) AND (next <> NIC) AND (crep.mMedial <> NIC)) then
      begin
          shaped[writeCount] := crep.mMedial; inc(writeCount);
          inc(i);continue;
          //* Final */
      end
      else if ((prev <> NIC) AND (crep.mFinal <> NIC)) then
      begin
          shaped[writeCount] := crep.mFinal; inc(writeCount);
          inc(i);continue;
          //* Initial */
      end
      else if ((next <> NIC) AND (crep.mInitial <> NIC)) then
      begin
          shaped[writeCount] := crep.mInitial; inc(writeCount);
          inc(i); continue;
      end;
      //* Isolated */
      shaped[writeCount] := crep.mIsolated; inc(writeCount);
    end
    else
    begin
      shaped[writeCount] := current; inc(writeCount);
    end;
    inc(i);
  end;

  result := shaped;
end;

end.

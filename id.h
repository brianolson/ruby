/**********************************************************************

  id.h - 

  $Author: ko1 $
  created at: Thu Jul 12 04:38:07 2007

  Copyright (C) 2007 Koichi Sasada

**********************************************************************/

#ifndef RUBY_ID_H
#define RUBY_ID_H

extern VALUE symIFUNC;
extern VALUE symCFUNC;

extern ID idPLUS;
extern ID idMINUS;
extern ID idMULT;
extern ID idDIV;
extern ID idMOD;
extern ID idLT;
extern ID idLTLT;
extern ID idLE;
extern ID idGT;
extern ID idGE;
extern ID idEq;
extern ID idEqq;
extern ID idNeq;
extern ID idNot;
extern ID idBackquote;
extern ID idEqTilde;
extern ID idThrowState;
extern ID idAREF;
extern ID idASET;
extern ID idIntern;
extern ID idMethodMissing;
extern ID idLength;
extern ID idGets;
extern ID idSucc;
extern ID idEach;
extern ID idLambda;
extern ID idRangeEachLT;
extern ID idRangeEachLE;
extern ID idArrayEach;
extern ID idTimes;
extern ID idEnd;
extern ID idBitblt;
extern ID idAnswer;
extern ID idSend;
extern ID id__send__;
extern ID idRespond_to;
extern ID idInitialize;

extern ID id_core_set_method_alias;
extern ID id_core_set_variable_alias;
extern ID id_core_undef_method;
extern ID id_core_define_method;
extern ID id_core_define_singleton_method;
extern ID id_core_set_postexe;

#endif /* RUBY_ID_H */

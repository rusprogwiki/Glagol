#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include "Htmlhelp.h"
#define Spravka_API __declspec(dllexport) void WINAPI 

BOOL WINAPI _DllMainCRTStartup(
  HMODULE hModule,DWORD ul_reason_for_call,LPVOID lpReserved) {
  return TRUE;
}

Spravka_API Kluch(wchar_t *imiaF,wchar_t *kluch) {
HH_AKLINK link;
  link.cbStruct    =sizeof(HH_AKLINK);
  link.fReserved   =FALSE;
  link.pszKeywords =kluch;
  link.pszUrl      =NULL;
  link.pszMsgText  =NULL;
  link.pszMsgTitle =NULL;
  link.pszWindow   =NULL;
  link.fIndexOnFail=TRUE;
  HtmlHelp(GetDesktopWindow(),imiaF,HH_KEYWORD_LOOKUP,(DWORD_PTR)&link);
}

Spravka_API Nomer(wchar_t *imiaF,int nomer) {
  HtmlHelp(GetDesktopWindow(),imiaF,HH_HELP_CONTEXT,nomer);
}

Spravka_API Razdel(wchar_t *imiaFRazdel) {
  HtmlHelp(GetDesktopWindow(),imiaFRazdel,HH_DISPLAY_TOPIC,(DWORD_PTR)NULL);
}

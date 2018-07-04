PRO EXCEPT

ojSession = OBJ_NEW('IDLJavaObject$IDLJAVABRIDGESESSION')
ojExc = ojSession ->GetException()
ojExc ->PrintStackTrace
ojVersion = ojSession ->GetVersionObject()
ojJavaVersion = ojVersion->GetJavaVersion()
ojBridge = ojVersion->GetBridgeVersion()

print, ojVersion
print, ojJavaVersion
print, ojBridge

END

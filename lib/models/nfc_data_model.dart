class NfcData {
  Nfca? nfca;
  Mifareultralight? mifareultralight;
  Ndef? ndef;

  NfcData({this.nfca, this.mifareultralight, this.ndef});

  NfcData.fromJson(Map<String, dynamic> json) {
    nfca = json['nfca'] != null ? Nfca.fromJson(json['nfca']) : null;
    mifareultralight = json['mifareultralight'] != null
        ? Mifareultralight.fromJson(json['mifareultralight'])
        : null;
    ndef = json['ndef'] != null ? Ndef.fromJson(json['ndef']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (nfca != null) {
      data['nfca'] = nfca!.toJson();
    }
    if (mifareultralight != null) {
      data['mifareultralight'] = mifareultralight!.toJson();
    }
    if (ndef != null) {
      data['ndef'] = ndef!.toJson();
    }
    return data;
  }
}

class Nfca {
  List<int>? identifier;
  List<int>? atqa;
  int? maxTransceiveLength;
  int? sak;
  int? timeout;

  Nfca(
      {this.identifier,
      this.atqa,
      this.maxTransceiveLength,
      this.sak,
      this.timeout});

  Nfca.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'].cast<int>();
    atqa = json['atqa'].cast<int>();
    maxTransceiveLength = json['maxTransceiveLength'];
    sak = json['sak'];
    timeout = json['timeout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identifier'] = identifier;
    data['atqa'] = atqa;
    data['maxTransceiveLength'] = maxTransceiveLength;
    data['sak'] = sak;
    data['timeout'] = timeout;
    return data;
  }
}

class Mifareultralight {
  List<int>? identifier;
  int? maxTransceiveLength;
  int? timeout;
  int? type;

  Mifareultralight(
      {this.identifier, this.maxTransceiveLength, this.timeout, this.type});

  Mifareultralight.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'].cast<int>();
    maxTransceiveLength = json['maxTransceiveLength'];
    timeout = json['timeout'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identifier'] = identifier;
    data['maxTransceiveLength'] = maxTransceiveLength;
    data['timeout'] = timeout;
    data['type'] = type;
    return data;
  }
}

class Ndef {
  List<int>? identifier;
  bool? isWritable;
  int? maxSize;
  bool? canMakeReadOnly;
  CachedMessage? cachedMessage;
  String? type;

  Ndef(
      {this.identifier,
      this.isWritable,
      this.maxSize,
      this.canMakeReadOnly,
      this.cachedMessage,
      this.type});

  Ndef.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'].cast<int>();
    isWritable = json['isWritable'];
    maxSize = json['maxSize'];
    canMakeReadOnly = json['canMakeReadOnly'];
    cachedMessage = json['cachedMessage'] != null
        ? CachedMessage.fromJson(json['cachedMessage'])
        : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identifier'] = identifier;
    data['isWritable'] = isWritable;
    data['maxSize'] = maxSize;
    data['canMakeReadOnly'] = canMakeReadOnly;
    if (cachedMessage != null) {
      data['cachedMessage'] = cachedMessage!.toJson();
    }
    data['type'] = type;
    return data;
  }
}

class CachedMessage {
  List<Records>? records;

  CachedMessage({this.records});

  CachedMessage.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (records != null) {
      data['records'] = records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Records {
  int? typeNameFormat;
  List<int>? type;
  List<dynamic>? identifier;
  List<int>? payload;

  Records({this.typeNameFormat, this.type, this.identifier, this.payload});

  Records.fromJson(Map<String, dynamic> json) {
    typeNameFormat = json['typeNameFormat'];
    type = json['type'].cast<int>();
    if (json['identifier'] != null) {
      identifier = <Null>[];
      json['identifier'].forEach((v) {
        
      });
    }
    payload = json['payload'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['typeNameFormat'] = typeNameFormat;
    data['type'] = type;
    if (identifier != null) {
      data['identifier'] = identifier!.map((v) => v.toJson()).toList();
    }
    data['payload'] = payload;
    return data;
  }
}

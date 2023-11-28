// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passkey_account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PasskeyAccountAdapter extends TypeAdapter<PasskeyAccount> {
  @override
  final int typeId = 0;

  @override
  PasskeyAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PasskeyAccount()
      ..passkey = fields[0] as PassKeyPair?
      ..initCode = fields[1] as String?
      ..address = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, PasskeyAccount obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.passkey)
      ..writeByte(1)
      ..write(obj.initCode)
      ..writeByte(2)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasskeyAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

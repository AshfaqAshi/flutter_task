
class React{
  String rc;
  int cn;

  React.fromJson(Map data){
    this.rc=data['rc'];
    this.cn=data['cn'];
  }
}
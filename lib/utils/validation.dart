class Validator{
  bool email(String em){
    return em.length >= 6; // dummy data
  }
  bool required(String em){
    return em.length >= 6;
  }
  bool password(String em){
    return em.length >= 6;
  }
  bool Name(String em){
    return em.length >= 6;
  }
  /// Implement extra stuff
}
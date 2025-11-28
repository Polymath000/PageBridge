sealed class EndPoint {
  const EndPoint();
  static const String baseUrl = 'https://api.notion.com/v1';
  // This endpoint need : Token (Authorization) ,and Notion-Version return list of database in the token
  // and body 
  static const String allDatabases = "$baseUrl/search";
  // This endpoint need : Token (Authorization) , Notion-Version and body 
  static const String addNewPage = "$baseUrl/pages/";
}

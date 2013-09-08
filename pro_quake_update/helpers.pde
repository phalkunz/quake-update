/**
 * This file contains helper functions for
 * string manipulation and such
 */
 
static String QUAKE_FEED = "http://www.geonet.org.nz/quakes/services/all.rss";

XML getFeedContent() {
  XML feed = loadXML(QUAKE_FEED);
  return feed;  
}

XML getFeedFirstItem(XML feed) {
  XML[] items = feed.getChildren("channel/item");
  return items[0];
}

/**
 * Give 2 string objects and a width
 * and returns a string that has spaces inserted in the middle
 * so that the returned string length is equal to the passed-in width
 * 
 * If the combined length of the 2 string objects is 
 * greater than or equal to the passed-in width, 
 * then just insert a single space char between them.
 */
String strJustify(String str1, String str2, int w) {
  String out;  
  
  str1 = str1.trim();
  str2 = str2.trim();
   
  if(str1.length() + str2.length() < w) {
    int numToPad = 0;
    String spaces = " ";
    
    numToPad = w - (str1.length() + str2.length());
    if(numToPad < 0) numToPad = numToPad * -1;
  
    spaces = String.format("%" + numToPad + "s", " ");
    out = str1 + spaces + str2;  
  }
  else {
    out = str1 + " " + str2;
  }
  
  return out;
}

/**
 * @obsolete because it doesn't seem accurate
 * Return km
 * lat and lon are in radians
 * 
 * http://www.movable-type.co.uk/scripts/latlong.html
 */
double distance(double lat1, double lon1, double lat2, double lon2) {
  double earthRadius = 6371; // km
  double x = (lon2 - lon1) * Math.cos((lat1 + lat2) / 2);
  double y = lat2 - lat1;
  
  return Math.sqrt((x * x) + (y * y)) * earthRadius;
}

/**
 * @obsolete
 */
double deg2rad(double deg) {
  return deg * (Math.PI/180);
}

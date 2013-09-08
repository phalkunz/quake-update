/**
 * Class representing a quake feed item
 */
class QuakeInfoItem {
  XML feedItem;
  double curLat; 
  double curLon;
  
  public QuakeInfoItem(XML feedItem, double curLat, double curLon) {
    this.feedItem = feedItem;
    this.curLat = curLat;
    this.curLon = curLon;
  }
  
  /**
   * Returns a string that uniquely identifies each quake feed item. 
   * In theory, GUID is good enough but there are times changes are made to magnitute
   * to an existing feed item and the GUID is still the same before the update
   */
  public String getID() {
    return this.getGUID() + " " + this.getMagnitute() + this.getLocation() + this.getFormattedTime();
  }
  
  public String getGUID() {
    return this.feedItem.getChildren("guid")[0].getContent();
  }
  
  public String getTitle() {
    return this.feedItem.getChildren("title")[0].getContent();
  }
  
  /**
   * Expected format to regex "Magnitute x.x"
   */
  public float getMagnitute() {
    String pattern = "Magnitude\\s*(\\d+\\.\\d+)";
    Pattern regex = Pattern.compile(pattern);
    Matcher matcher = regex.matcher(this.getTitle());
    if (matcher.find()) {
        return Float.parseFloat(matcher.group(1));
    }
    else {
      return 0.0;
    }
  }
  
  public String getFormattedMagnitute() {
    return "M" + this.getMagnitute();
  }
  
  public Date getDateTime() {
    // Input format: e.g. "September 8 2013"
    Pattern dateRegex = Pattern.compile("(\\w+\\s+\\d{1,2}\\s\\d{2,4})");
    Matcher dateMatcher = dateRegex.matcher(this.getTitle());
    // Input format: e.g. "2:21:25 pm"
    Pattern timeRegex = Pattern.compile("(\\d{1,2}:\\d{1,2}:\\d{1,2}\\s\\w{2})");
    Matcher timeMatcher = timeRegex.matcher(this.getTitle());
    
    if(dateMatcher.find() && timeMatcher.find()) {
      SimpleDateFormat ft = new SimpleDateFormat("MMMM d yyyy h:mm:ss a");
      
      try {
          return ft.parse(dateMatcher.group(1) + " " + timeMatcher.group(1));
      } catch (ParseException e) { 
          System.out.println("Unparseable using " + ft);
          return null;
      }
    }
    else {
      return null;
    }
  }
  
  public String getFormattedDate() {
    SimpleDateFormat ft = new SimpleDateFormat ("dd/MM/yy");
    return ft.format(this.getDateTime());
  }
  
  public String getFormattedTime() {
    SimpleDateFormat ft = new SimpleDateFormat ("HH:mm");
    return ft.format(this.getDateTime());
  }
  
  public String getLocation() {
    String title = this.getTitle();
    Pattern locationRegex = Pattern.compile("of\\s+([\\s\\w]+)$");
    Matcher locationMatcher = locationRegex.matcher(title);
    
    if(locationMatcher.find()) {
       return locationMatcher.group(1);
    }
    else {
      return "";
    }
  }
  
  /**
   * @obsolete due to high level of inaccuracy
   */
  public double getDistance() {
    double lat1 = deg2rad(this.curLat);
    double lon1 = deg2rad(this.curLon);
    double lat2 = deg2rad(this.getLat());
    double lon2 = deg2rad(this.getLon());
    double distance = distance(lat1, lon1, lat2, lon2);
    
    return distance;
  }
  
  /**
   * @obsolete
   */
  public String getFormattedDistance() {
    return String.format("%.1fK", this.getDistance());
  }
  
  public double getLat() {
    return Double.parseDouble(this.feedItem.getChildren("geo:lat")[0].getContent());
  }
  
  public double getLon() {
    return Double.parseDouble(this.feedItem.getChildren("geo:long")[0].getContent());
  }
}


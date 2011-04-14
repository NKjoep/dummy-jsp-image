<%--
	Title: 
		image generator as dummyimage
	Author:
		Andrea Dessì <a.dessi@agiletec.it>
	Date:
		12/apr/2011 17.52.24
	Usage: 
		place this jsp in your webapp, then point your browser to:
		java-img.jsp?img=/<WIDTH>x<HEIGHT>/<HEX-BACKGROUND>/<HEX-FOREGROUND>&text=
		
		example:
		java-img.jsp?img=/640x480/000/fff&text=this is a test
--%>
<%@page import="com.sun.image.codec.jpeg.JPEGEncodeParam"%>
<%@page import="com.sun.image.codec.jpeg.*" %>
<%@page import="java.awt.Color" %>
<%@page import="java.awt.Font" %>
<%@page import="java.awt.FontMetrics" %>
<%@page import="java.awt.Graphics" %>
<%@page import="java.awt.image.BufferedImage" %>
<%@page import="java.io.*" %>
<%@page import="javax.servlet.http.*" %>
<%@page import="javax.servlet.*" %>
<%
	int rWidth = 200; //default width
	int rHeight = 200; //default height
	int FONT_HEIGHT = 10; //default fontsize
	String FONT_TYPE = "Arial"; //default font
	float QUALITY = 1f; //default image quality
	String rBackground = "#CCCCCC"; //default background
	String rColor = "#000000"; //default font color
	
	ServletOutputStream myout = response.getOutputStream(); //the output stream
	String[] params = request.getParameter("img").split("/"); //the parameters
	String paramText = request.getParameter("text"); //the text in your image
	
	String rText = "";
	for(int cp = 1;cp<params.length;cp++) {
		String current = params[cp];
		if (current!=null && current.trim().length()>0) {
			if (cp==1) {
				if (current.equalsIgnoreCase("cga")) {
					rWidth = 320; rHeight = 200;
				} else if (current.equalsIgnoreCase("qvga")) {
					rWidth = 320; rHeight = 240;
				} else if (current.equalsIgnoreCase("vga")) {
					rWidth = 640; rHeight = 480;
				} else if (current.equalsIgnoreCase("wvga")) {
					rWidth = 800; rHeight = 480;
				} else if (current.equalsIgnoreCase("svga")) {
					rWidth = 800; rHeight = 480;
				} else if (current.equalsIgnoreCase("wsvga")) {
					rWidth = 1024; rHeight = 600;
				} else if (current.equalsIgnoreCase("xga")) {
					rWidth = 1024; rHeight = 768;
				} else if (current.equalsIgnoreCase("wxga")) {
					rWidth = 1280; rHeight = 800;
				} else if (current.equalsIgnoreCase("wsxga")) {
					rWidth = 1440; rHeight = 900;
				} else if (current.equalsIgnoreCase("wuxga")) {
					rWidth = 1920; rHeight = 1200;
				} else if (current.equalsIgnoreCase("wqxga")) {
					rWidth = 2560; rHeight = 1600;
				} else if (current.equalsIgnoreCase("ntsc")) {
					rWidth = 720; rHeight = 480; 
				} else if (current.equalsIgnoreCase("pal")) {
					rWidth = 768; rHeight = 576;
				} else if (current.equalsIgnoreCase("hd720")) {
					rWidth = 1280; rHeight = 720;
				} else if (current.equalsIgnoreCase("hd1080")) {
					rWidth = 1920; rHeight = 1080; 
				}
				else {
					String[] mysplit = current.split("x");
					try {
						rWidth = (int) Integer.valueOf(mysplit[0]) ;
						rHeight = (int) Integer.valueOf(mysplit[mysplit.length-1]);
					}
					catch(NumberFormatException err) {
					}
					//System.out.println("dim: "+rWidth+" x "+rHeight);
				}
				
			}
			else if (cp == 2||cp==3) {
				String tmpBackground = "";
				if (current.length()>0 && current.length()< 7) {
					if 	(current.length()==4 || current.length()==5 || current.length()==6) {
						current = current.substring(0,2);
					}    
				}
				switch (current.length()) {
					case (1): 
						tmpBackground = current+current+current+current+current+current;
						break;
					case (2): 
						tmpBackground = current+current+current;
						break;
					case (3): 
						tmpBackground = current.substring(0,1)+current.substring(0,1)+current.substring(1,2)+current.substring(1,2)+current.substring(2,3)+current.substring(2,3);
						break;
					default: 
						tmpBackground = current;
				}
				if (cp == 2) {
					rBackground = "#"+tmpBackground.toUpperCase();
				}
				else if (cp == 3) {
					rColor = "#"+tmpBackground.toUpperCase();
				}
				//System.out.println("color " +cp+ "  " + "#"+tmpBackground.toUpperCase());
			}
		}
		//System.out.println("\tcp: "+current);
	}
	
	rText = rWidth+" x " +rHeight;
	if (paramText!=null&&paramText.trim().length()>0) {
		rText = paramText;
	}

	int WIDTH = rWidth;
	int HEIGHT = rHeight;

	Color BACKGROUND_COLOR = Color.decode(rBackground);
	Color COLOR = Color.decode(rColor);
	
	if ((WIDTH/rText.length())+15 < HEIGHT/2) {
		FONT_HEIGHT = (WIDTH/rText.length())+15; 
	}
	else {
		FONT_HEIGHT = (HEIGHT/2)-5;
	}
	
	Font FONT = new Font(FONT_TYPE, Font.CENTER_BASELINE, FONT_HEIGHT);
	BufferedImage image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_BYTE_INDEXED);
	Graphics graphics = image.getGraphics();
	graphics.setColor(BACKGROUND_COLOR);
	graphics.fillRect(0, 0, image.getWidth(), image.getHeight());
	graphics.setColor(COLOR);
	
	graphics.setFont(FONT);
	graphics.setColor(COLOR);
	
    // Get measures needed to center the message
	FontMetrics fm = graphics.getFontMetrics();
	 // How many pixels wide is the string
    int msg_width = fm.stringWidth (rText);
	// How far above the baseline can the font go?
	int ascent = fm.getMaxAscent ();
	// How far below the baseline?
	int descent= fm.getMaxDescent ();
	// Use the string width to find the starting point
	int msg_x = WIDTH/2 - msg_width/2;
	// Use the vertical height of this font to find  the vertical starting coordinate
	int msg_y = HEIGHT/2 - descent/2 + ascent/2;		
	//write everything
	graphics.drawString (rText, msg_x, msg_y);

	//process the image
	JPEGImageEncoder img = JPEGCodec.createJPEGEncoder(myout);
	JPEGEncodeParam param = img.getDefaultJPEGEncodeParam(image);
	param.setQuality(QUALITY, false);
	response.setContentType("image/jpg");
	img.encode(image,param);
%>
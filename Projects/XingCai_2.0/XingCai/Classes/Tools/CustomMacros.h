//
//  CustomMacros.h
//  XingCai
//
//  Created by Villiam on 10/22/14.
//  Copyright (c) 2014 weststar. All rights reserved.
//

#ifndef XingCai_CustomMacros_h
#define XingCai_CustomMacros_h

//Color
#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HEXRGBCOLOR(h) RGBCOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF))
#define HEXRGBACOLOR(h,a) RGBACOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF), a)
#endif


//RED
#define GUI_COLOR__viRed_Bar RGBCOLOR(244,58,58)

#define GUI_COLOR__TextRed RGBCOLOR(225,51,95)
#define GUI_COLOR__TextRedLighter RGBCOLOR(225,171,145)

//BLACK
#define GUI_COLOR__TextBLACK RGBCOLOR(64,64,64)

//GREY
#define GUI_COLOR_TextGREY RGBCOLOR(146,146,146)
#define GUI_COLOR_TextGREYLighter RGBCOLOR(178,178,178)

//white
#define GUI_COLOR_NAVIGATION_BAR_TEXT RGBCOLOR(255,255,255)

//----------
#define GUI_COLOR_TABLECELL_BG RGBCOLOR(253,253,244)
#define GUI_COLOR_TABBAR_BG RGBCOLOR(245,245,235)
#define GUI_COLOR_VIEWCONTROLLER_BG RGBCOLOR(253,253,244)
#endif

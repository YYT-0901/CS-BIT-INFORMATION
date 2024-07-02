#include <gl/glut.h>

 

GLfloat rx=0, ry=0 ,angle=0;

GLint winWidth=600, winHeight=600;

GLint mouseDx,mouseDy;

 

 

//////////显示函数

void Display(){

    ////////GL_COLOR_BUFFER_BIT(用背景颜色填充)

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

 

//glPushMatrix();

 

    glRotatef(1, rx, ry, 0);

 

glColor3f(0.0,0.0,1.0);

 

    //glutWireTeapot(160);

glutSolidTeapot(120);

 

//glPopMatrix();

 

    ///交换缓冲区

glutSwapBuffers();

//glFlush();// 刷新绘图命令

}

 

 

// 设置渲染状态（听起来满下人，实际上很简单）

void SetupRC(void)

{

//清除颜色（这里为黑色，为了方便找画的那个点），可以理解成背景颜色

//和glColor4f(1.0f, 0.0f, 0.0f，1.0f)一样，所有参数都在0.0到1.0之间，后缀f是表示参数是浮点型的

//最后的那个1.0f是透明度，0.0f表示全透明，1.0f是完全不透明

glClearColor(1.0f, 1.0f, 1.0f,1.0f);

}

 

// 当绘制的窗口大小改变时重新绘制，使绘制的图形同比例变化，

//几乎所有OpenGL程序中的这个函数都是一样的，所以，放心大胆的拷贝吧

void ChangeSize(int w, int h)

{

winWidth = w;

winHeight = h;

// 设置观察视野为窗口大小（用FLASH里面的话来说应该叫设置摄象机视野）

glViewport(0,0,w,h);

// 重置坐标系统，指定设置投影参数

glMatrixMode(GL_PROJECTION);

///////调用单位矩阵，去掉以前的投影参数设置

glLoadIdentity();

    //////设置投影参数

glOrtho(-w/2,w/2,-h/2,h/2,-w,w);

 

glMatrixMode( GL_MODELVIEW );

glLoadIdentity();

}

 

 

void init() //初始化背景颜色，光照，材质等 

{

glClearColor(0.9,0.9,0.8,1.0); //初始背景色 

/********* 光照处理 **********/ 

GLfloat light_ambient[] = { 0.0, 0.0, 0.0, 1.0 };

GLfloat light_diffuse[] = { 1.0, 1.0, 1.0, 1.0 };

GLfloat light_specular[] = { 1.0, 1.0, 1.0, 1.0 };

GLfloat light_position0[] = { 100.0, 100.0, 100.0 ,0 }; 

//定义光位置得齐次坐标(x,y,z,w),如果w=1.0,为定位光源（也叫点光源），

//如果w＝0，为定向光源（无限光源），定向光源为无穷远点，因而产生光为 

//平行光。 

glLightfv(GL_LIGHT0, GL_AMBIENT , light_ambient ); //环境光 

glLightfv(GL_LIGHT0, GL_DIFFUSE , light_diffuse ); //漫射光 

glLightfv(GL_LIGHT0, GL_SPECULAR, light_specular); //镜面反射 

glLightfv(GL_LIGHT0, GL_POSITION, light_position0); //光照位置 

/******** 材质处理 ***********/ 

GLfloat mat_ambient[] = { 0.0, 0.2, 1.0, 1.0 };

GLfloat mat_diffuse[] = { 0.8, 0.5, 0.2, 1.0 }; 

GLfloat mat_specular[] = { 1.0, 1.0, 1.0, 1.0 };

GLfloat mat_shininess[] = { 100.0 }; //材质RGBA镜面指数，数值在0～128范围内 

 

glMaterialfv(GL_FRONT, GL_AMBIENT, mat_ambient);

glMaterialfv(GL_FRONT, GL_DIFFUSE, mat_diffuse);

glMaterialfv(GL_FRONT, GL_SPECULAR, mat_specular);

glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess); 

glEnable(GL_LIGHTING); //启动光照 

glEnable(GL_LIGHT0); //使第一盏灯有效 

glEnable(GL_DEPTH_TEST); //测试深度缓存 

/******** 其他可选项 ***********/ 

// glDepthFunc(GL_LESS); //函数指定比较函数，用来比较每个引入象素的z值和深度缓存中给定的z值，只有当

//激活深度检验时才执行此比较。 

// glEnable(GL_CULL_FACE); //剔除多边形表面:在三维空间中，一个多边形虽然有两个面，但我们无法看见背

//面的那些多边形，而一些多边形虽然是正面的，但被其他多边形所遮挡。如果将

//无法看见的多边形和可见的多边形同等对待，无疑会降低我们处理图形的效率。

//在这种时候，可以将不必要的面剔除。

// glCullFace(GL_FRONT); //glCullFace的参数可以是GL_FRONT，GL_BACK或者GL_FRONT_AND_BACK，分别表示

//剔除正面、剔除反面、剔除正反两面的多边形。

// glEnable(GL_COLOR_MATERIAL); //材质颜色追踪当前颜色

} 

 

 

/////////////////鼠标点击

void MousePlot(GLint button,GLint action,GLint xMouse,GLint yMouse){

if(button==GLUT_LEFT_BUTTON && action==GLUT_DOWN){

mouseDx = xMouse;

    mouseDy = yMouse;

}

    if(button==GLUT_LEFT_BUTTON && action==GLUT_UP){

    glutPostRedisplay();

}

}

////////////////鼠标移动

void MouseMove(GLint xMouse,GLint yMouse){

 

//angle+=2;

if(xMouse>mouseDx && yMouse==mouseDy)

{rx=0;ry=1;}

else if(xMouse<mouseDx && yMouse==mouseDy)

{rx=0;ry=-1;}

else if(xMouse==mouseDx && yMouse<mouseDy)

{rx=-1;ry=0;}

else if(xMouse==mouseDx && yMouse>mouseDy)

{rx=1;ry=0;}

else if(xMouse>mouseDx && yMouse<mouseDy)

{rx=-1;ry=1;} 

else if(xMouse>mouseDx && yMouse>mouseDy)

{rx=1;ry=1;}

else if(xMouse<mouseDx && yMouse<mouseDy)

{rx=-1;ry=-1;}

else if(xMouse<mouseDx && yMouse>mouseDy)

{rx=1;ry=-1;}

 

       

mouseDx = xMouse;

mouseDy = yMouse;

glutPostRedisplay();

}

 

// 主函数

int main(int argc, char* argv[])

{

glutInit(&argc, argv);

//设置显示模式

glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);

//设置窗口大小像素

glutInitWindowSize(600, 600);

////设置窗口出现在屏幕的位置

glutInitWindowPosition(300,160);

//建立一个叫OpenGL的窗口

glutCreateWindow("鼠标旋转的茶壶");

 

//调用函数Display进行绘制

glutDisplayFunc(Display);

    //////调用鼠标移动函数

    //glutPassiveMotionFunc(PassiveMouseMove);

glutMotionFunc(MouseMove);

//////调用鼠标点击函数

glutMouseFunc(MousePlot);

 

//如果窗口大小改变则调用函数ChangeSize重新进行绘制

glutReshapeFunc(ChangeSize);

 

    init();

 

//清屏

//SetupRC();

//循环绘制

glutMainLoop();

 

return 0;

}
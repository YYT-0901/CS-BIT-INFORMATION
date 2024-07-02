#include <gl/glut.h>

 

GLfloat rx=0, ry=0 ,angle=0;

GLint winWidth=600, winHeight=600;

GLint mouseDx,mouseDy;

 

 

//////////��ʾ����

void Display(){

    ////////GL_COLOR_BUFFER_BIT(�ñ�����ɫ���)

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

 

//glPushMatrix();

 

    glRotatef(1, rx, ry, 0);

 

glColor3f(0.0,0.0,1.0);

 

    //glutWireTeapot(160);

glutSolidTeapot(120);

 

//glPopMatrix();

 

    ///����������

glutSwapBuffers();

//glFlush();// ˢ�»�ͼ����

}

 

 

// ������Ⱦ״̬�������������ˣ�ʵ���Ϻܼ򵥣�

void SetupRC(void)

{

//�����ɫ������Ϊ��ɫ��Ϊ�˷����һ����Ǹ��㣩���������ɱ�����ɫ

//��glColor4f(1.0f, 0.0f, 0.0f��1.0f)һ�������в�������0.0��1.0֮�䣬��׺f�Ǳ�ʾ�����Ǹ����͵�

//�����Ǹ�1.0f��͸���ȣ�0.0f��ʾȫ͸����1.0f����ȫ��͸��

glClearColor(1.0f, 1.0f, 1.0f,1.0f);

}

 

// �����ƵĴ��ڴ�С�ı�ʱ���»��ƣ�ʹ���Ƶ�ͼ��ͬ�����仯��

//��������OpenGL�����е������������һ���ģ����ԣ����Ĵ󵨵Ŀ�����

void ChangeSize(int w, int h)

{

winWidth = w;

winHeight = h;

// ���ù۲���ҰΪ���ڴ�С����FLASH����Ļ���˵Ӧ�ý������������Ұ��

glViewport(0,0,w,h);

// ��������ϵͳ��ָ������ͶӰ����

glMatrixMode(GL_PROJECTION);

///////���õ�λ����ȥ����ǰ��ͶӰ��������

glLoadIdentity();

    //////����ͶӰ����

glOrtho(-w/2,w/2,-h/2,h/2,-w,w);

 

glMatrixMode( GL_MODELVIEW );

glLoadIdentity();

}

 

 

void init() //��ʼ��������ɫ�����գ����ʵ� 

{

glClearColor(0.9,0.9,0.8,1.0); //��ʼ����ɫ 

/********* ���մ��� **********/ 

GLfloat light_ambient[] = { 0.0, 0.0, 0.0, 1.0 };

GLfloat light_diffuse[] = { 1.0, 1.0, 1.0, 1.0 };

GLfloat light_specular[] = { 1.0, 1.0, 1.0, 1.0 };

GLfloat light_position0[] = { 100.0, 100.0, 100.0 ,0 }; 

//�����λ�õ��������(x,y,z,w),���w=1.0,Ϊ��λ��Դ��Ҳ�е��Դ����

//���w��0��Ϊ�����Դ�����޹�Դ���������ԴΪ����Զ�㣬���������Ϊ 

//ƽ�й⡣ 

glLightfv(GL_LIGHT0, GL_AMBIENT , light_ambient ); //������ 

glLightfv(GL_LIGHT0, GL_DIFFUSE , light_diffuse ); //����� 

glLightfv(GL_LIGHT0, GL_SPECULAR, light_specular); //���淴�� 

glLightfv(GL_LIGHT0, GL_POSITION, light_position0); //����λ�� 

/******** ���ʴ��� ***********/ 

GLfloat mat_ambient[] = { 0.0, 0.2, 1.0, 1.0 };

GLfloat mat_diffuse[] = { 0.8, 0.5, 0.2, 1.0 }; 

GLfloat mat_specular[] = { 1.0, 1.0, 1.0, 1.0 };

GLfloat mat_shininess[] = { 100.0 }; //����RGBA����ָ������ֵ��0��128��Χ�� 

 

glMaterialfv(GL_FRONT, GL_AMBIENT, mat_ambient);

glMaterialfv(GL_FRONT, GL_DIFFUSE, mat_diffuse);

glMaterialfv(GL_FRONT, GL_SPECULAR, mat_specular);

glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess); 

glEnable(GL_LIGHTING); //�������� 

glEnable(GL_LIGHT0); //ʹ��һյ����Ч 

glEnable(GL_DEPTH_TEST); //������Ȼ��� 

/******** ������ѡ�� ***********/ 

// glDepthFunc(GL_LESS); //����ָ���ȽϺ����������Ƚ�ÿ���������ص�zֵ����Ȼ����и�����zֵ��ֻ�е�

//������ȼ���ʱ��ִ�д˱Ƚϡ� 

// glEnable(GL_CULL_FACE); //�޳�����α���:����ά�ռ��У�һ���������Ȼ�������棬�������޷�������

//�����Щ����Σ���һЩ�������Ȼ������ģ�����������������ڵ��������

//�޷������Ķ���κͿɼ��Ķ����ͬ�ȶԴ������ɻή�����Ǵ���ͼ�ε�Ч�ʡ�

//������ʱ�򣬿��Խ�����Ҫ�����޳���

// glCullFace(GL_FRONT); //glCullFace�Ĳ���������GL_FRONT��GL_BACK����GL_FRONT_AND_BACK���ֱ��ʾ

//�޳����桢�޳����桢�޳���������Ķ���Ρ�

// glEnable(GL_COLOR_MATERIAL); //������ɫ׷�ٵ�ǰ��ɫ

} 

 

 

/////////////////�����

void MousePlot(GLint button,GLint action,GLint xMouse,GLint yMouse){

if(button==GLUT_LEFT_BUTTON && action==GLUT_DOWN){

mouseDx = xMouse;

    mouseDy = yMouse;

}

    if(button==GLUT_LEFT_BUTTON && action==GLUT_UP){

    glutPostRedisplay();

}

}

////////////////����ƶ�

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

 

// ������

int main(int argc, char* argv[])

{

glutInit(&argc, argv);

//������ʾģʽ

glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);

//���ô��ڴ�С����

glutInitWindowSize(600, 600);

////���ô��ڳ�������Ļ��λ��

glutInitWindowPosition(300,160);

//����һ����OpenGL�Ĵ���

glutCreateWindow("�����ת�Ĳ��");

 

//���ú���Display���л���

glutDisplayFunc(Display);

    //////��������ƶ�����

    //glutPassiveMotionFunc(PassiveMouseMove);

glutMotionFunc(MouseMove);

//////�������������

glutMouseFunc(MousePlot);

 

//������ڴ�С�ı�����ú���ChangeSize���½��л���

glutReshapeFunc(ChangeSize);

 

    init();

 

//����

//SetupRC();

//ѭ������

glutMainLoop();

 

return 0;

}
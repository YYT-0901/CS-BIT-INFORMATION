## QT进行网络请求

1. 在`.pro`文件添加
  ```
  QT += webenginewidgets
  ```

2. 代码

   ```c++
   #include "widget.h"
   #include "ui_widget.h"
   
   #include <QtNetwork/QNetworkAccessManager>
   #include <QtNetwork/QNetworkReply>
   
   #include <QByteArray>
   #include <QJsonDocument>
   #include <QJsonObject>
   #include <QMessageBox>
   
   Widget::Widget(QWidget *parent)
       : QWidget(parent)
       , ui(new Ui::Widget)
   {
       ui->setupUi(this);
   
       QJsonObject convertJsonStringToObj(QByteArray);
   
       // http request
       QNetworkAccessManager *manager = new QNetworkAccessManager(this);
   
       // TODO:define url request api
       QString strURL = "http://10.194.42.64:7070/api/notifications/getTitle";
       QUrl url(strURL);
       QNetworkRequest request(url);
   
       // use get method request
       QNetworkReply *reply = manager->get(request);
   
       // 对reply进行绑定, invoke method readHttpReply
       QObject::connect(manager, &QNetworkAccessManager::finished,
                        this, [=]() {
           QByteArray result;
           if(reply->error() == QNetworkReply::NoError) {
               // handle no error
               result = reply->readAll();
           } else {
               // handle error
               QMessageBox::warning(this, "error", reply->errorString());
               return;
           }
           // 对于Json
           QJsonObject jsonObject = convertJsonStringToObj(result);
           // TODO:do something when get result
           qDebug() << jsonObject;
                            
           // 对于图片流
           QImage image;
           if(image.loadFromData(imageData)) {
               // 显示图片
               QLabel *imageLabel = new QLabel(this);
               imageLabel->setPixmap(QPixmap::fromImage(image).scaled(100, 100, Qt::KeepAspectRatio));
               imageLabel->show();
           } else {
               QMessageBox::warning(this, "Error", "Cannot load image from data.");
               return;
           }
       });
   }
   
   Widget::~Widget()
   {
       delete ui;
   }
   
   QJsonObject convertJsonStringToObj(QByteArray result) {
       QJsonDocument jsonDoc = QJsonDocument::fromJson(result);
       if(!jsonDoc.isNull() && jsonDoc.isObject()) {
           return jsonDoc.object();
       }
       return {};
   }
   
   ```

   


---



# MyChat接口文档

基础路基：`/api`

### 获取验证码

`/userInfo/checkCode`

无参数

> 返回
>
> ```json
> {
>     "status": "success",
>     "code": 200,
>     "info": "请求成功",
>     "data": {
>         "check_code_key": "d82ced2e-1c79-49bd-9d0c-9bccac892615",
>         "check_code": "data:image/png;base64,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"
>     }
> }
> ```



###  获取邮箱验证码

`/userInfo/sendEmailCode`

| 参数      | 说明                           | 类型   | 是否必传 |
| --------- | ------------------------------ | ------ | -------- |
| email     | 邮箱                           | String | √        |
| checkCode | 图片验证码                     | String | √        |
| key       | 获取验证码返回的check_code_key | String | √        |

> 返回
>
> 查看输入的邮箱



### 用户注册

`/userInfo/register`

| 参数      | 说明             | 类型   | 是否必传 |
| --------- | ---------------- | ------ | -------- |
| username  | 用户名           | String | √        |
| password  | 密码             | String | √        |
| emailCode | 邮箱验证码验证码 | String | √        |
| phone     | 手机号           | String | ×        |
| email     | 邮箱             | String | √        |

> 返回
>
> ```json
> {
>  "status": "success",
>  "code": 200,
>  "info": "请求成功",
>  "data": null
> }
> ```



### 用户登录

`/userInfo/login`

| 参数      | 说明       | 类型   | 是否必传 |
| --------- | ---------- | ------ | -------- |
| email     | 邮箱       | String | √        |
| password  | 密码       | String | √        |
| checkCode | 图片验证码 | String | √        |
| key       | 获取验证码返回的check_code_key | String | √        |

> 返回
>
> ```json
> {
>     "status": "success",
>     "code": 200,
>     "info": "请求成功",
>     "data": {
>         "userId": "4665322800",
>         "email": "1820221050@bit.edu.cn",
>         "phone": "18111111112",
>         "nickName": "新世界的神",
>         "joinType": 0,
>         "sex": null,
>         "password": "0192023a7bbd73250516f069df18b500",
>         "personalSignature": null,
>         "createTime": "2024-08-26 23:56:28",
>         "lastLoginTime": "2024-08-27 00:16:52",
>         "lastOffTime": null
>     }
> }
> ```



---



# 系统设置

### 获取系统文件存储路径

`/systemFilePath/getSystemFilePath`

> 返回:
>
> ```json
> {
>     "status": "success",
>     "code": 200,
>     "info": "请求成功",
>     "data": "/image/path"
> }
> ```



### 设置系统文件存储路劲

`/systemFilePath/saveFilePath`

| 参数 | 说明     | 类型   | 是否必传 |
| ---- | -------- | ------ | -------- |
| path | 存的数据 | String | √        |


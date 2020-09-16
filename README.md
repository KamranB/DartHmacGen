# DartHmacGen
Generate hmac authentication header from given url, content, app id and app secret using dart. Most common use is in calling an API which requires hmac authentication.


Copy the file in your project and use `getHmacAuthHeader` function to generate hmac authorization header.
Here is a simple example of how I used it with dio to call an API.
```Dart
    Dio dio = Dio(BaseOptions(
      baseUrl: BASE_URl,
      headers: {
        "Authorization": getHmacAuthHeader(
          inputUrl: _url,
          inputJsonContent: _body,
          appId: appId,
          appSecrets: appSecret,
        )
      },
      responseType: ResponseType.json,
      connectTimeout: 100000,
      receiveTimeout: 100000,
    ));
```
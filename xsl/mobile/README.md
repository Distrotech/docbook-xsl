### Note :
In previous version, it has some components from the "PhoneGap". But it seems to be not the objective of DocBook XSL mobile. Using this package user can build mobile output and separately download PhoneGap package and replace with it's asserts at build time.

###	How to Use it ?

1. First you have to download the docbook xsl-1.77.1 version from http://sourceforge.net/projects/docbook/files/docbook-xsl/1.77.1/
2. Also download the Mobile package as zip from here.
3. Then add Mobile directory into docbook-xsl like docbook-xsl-1.77.1/mobile.
4. (Optional) Then replace old docbook-xsl-1.77.1/extensions/webhelpIndexer.jar
  Now, you finished with settings up the package to use.

To see how to use the this package please read documentation at http://gihankarunarathne.github.com/DocBook-xsl-mobile/content/index.html

### Support Platforms
	
#####  List of Available mobile platforms ::
```
  |
  |_Android             :$ant android-help *
  |__Apple iOS          :$ant iOS-help *
  |___Blackberry        :$ant blackberry-help
  |____Palm webOS
  |_____Samsung Bada
  |______Windows Phone	:$ant windows-phone-help
  ```
```    key: " * " - currently implemented```

### HTMLs for web view

To create HTML for web view:
```
	$ ant mobile.web
```

### Build using PhoneGap Build

To create asserts zip file for build using PhoneGap cloud service at https://build.phonegap.com/
Note: Don't need to install any tool or SDK
```

  $ ant mobile
```

### Android

To create Android .apk app with using chunked htmls :
```
  $ ant mobile.android
```
### iOS

To create Apple iOS app with using chunked htmls :
```
  $ ant mobile.iOS
```

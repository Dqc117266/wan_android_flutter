class TreeModel {
  List<Data>? _data;
  int? _errorCode;
  String? _errorMsg;

  TreeModel({List<Data>? data, int? errorCode, String? errorMsg}) {
    if (data != null) {
      this._data = data;
    }
    if (errorCode != null) {
      this._errorCode = errorCode;
    }
    if (errorMsg != null) {
      this._errorMsg = errorMsg;
    }
  }

  List<Data>? get data => _data;
  set data(List<Data>? data) => _data = data;
  int? get errorCode => _errorCode;
  set errorCode(int? errorCode) => _errorCode = errorCode;
  String? get errorMsg => _errorMsg;
  set errorMsg(String? errorMsg) => _errorMsg = errorMsg;

  TreeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      _data = <Data>[];
      json['data'].forEach((v) {
        _data!.add(new Data.fromJson(v));
      });
    }
    _errorCode = json['errorCode'];
    _errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._data != null) {
      data['data'] = this._data!.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this._errorCode;
    data['errorMsg'] = this._errorMsg;
    return data;
  }
}

class Data {
  List? _articleList;
  String? _author;
  List<Children>? _children;
  int? _courseId;
  String? _cover;
  String? _desc;
  int? _id;
  String? _lisense;
  String? _lisenseLink;
  String? _name;
  int? _order;
  int? _parentChapterId;
  int? _type;
  bool? _userControlSetTop;
  int? _visible;

  Data(
      {List? articleList,
        String? author,
        List<Children>? children,
        int? courseId,
        String? cover,
        String? desc,
        int? id,
        String? lisense,
        String? lisenseLink,
        String? name,
        int? order,
        int? parentChapterId,
        int? type,
        bool? userControlSetTop,
        int? visible}) {
    if (articleList != null) {
      this._articleList = articleList;
    }
    if (author != null) {
      this._author = author;
    }
    if (children != null) {
      this._children = children;
    }
    if (courseId != null) {
      this._courseId = courseId;
    }
    if (cover != null) {
      this._cover = cover;
    }
    if (desc != null) {
      this._desc = desc;
    }
    if (id != null) {
      this._id = id;
    }
    if (lisense != null) {
      this._lisense = lisense;
    }
    if (lisenseLink != null) {
      this._lisenseLink = lisenseLink;
    }
    if (name != null) {
      this._name = name;
    }
    if (order != null) {
      this._order = order;
    }
    if (parentChapterId != null) {
      this._parentChapterId = parentChapterId;
    }
    if (type != null) {
      this._type = type;
    }
    if (userControlSetTop != null) {
      this._userControlSetTop = userControlSetTop;
    }
    if (visible != null) {
      this._visible = visible;
    }
  }

  List? get articleList => _articleList;
  set articleList(List? articleList) => _articleList = articleList;
  String? get author => _author;
  set author(String? author) => _author = author;
  List<Children>? get children => _children;
  set children(List<Children>? children) => _children = children;
  int? get courseId => _courseId;
  set courseId(int? courseId) => _courseId = courseId;
  String? get cover => _cover;
  set cover(String? cover) => _cover = cover;
  String? get desc => _desc;
  set desc(String? desc) => _desc = desc;
  int? get id => _id;
  set id(int? id) => _id = id;
  String? get lisense => _lisense;
  set lisense(String? lisense) => _lisense = lisense;
  String? get lisenseLink => _lisenseLink;
  set lisenseLink(String? lisenseLink) => _lisenseLink = lisenseLink;
  String? get name => _name;
  set name(String? name) => _name = name;
  int? get order => _order;
  set order(int? order) => _order = order;
  int? get parentChapterId => _parentChapterId;
  set parentChapterId(int? parentChapterId) =>
      _parentChapterId = parentChapterId;
  int? get type => _type;
  set type(int? type) => _type = type;
  bool? get userControlSetTop => _userControlSetTop;
  set userControlSetTop(bool? userControlSetTop) =>
      _userControlSetTop = userControlSetTop;
  int? get visible => _visible;
  set visible(int? visible) => _visible = visible;

  Data.fromJson(Map<String, dynamic> json) {
    if (json['articleList'] != null) {
      _articleList = [];
    }
    _author = json['author'];
    if (json['children'] != null) {
      _children = <Children>[];
      json['children'].forEach((v) {
        _children!.add(new Children.fromJson(v));
      });
    }
    _courseId = json['courseId'];
    _cover = json['cover'];
    _desc = json['desc'];
    _id = json['id'];
    _lisense = json['lisense'];
    _lisenseLink = json['lisenseLink'];
    _name = json['name'];
    _order = json['order'];
    _parentChapterId = json['parentChapterId'];
    _type = json['type'];
    _userControlSetTop = json['userControlSetTop'];
    _visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._articleList != null) {
      data['articleList'] = this._articleList!.map((v) => v.toJson()).toList();
    }
    data['author'] = this._author;
    if (this._children != null) {
      data['children'] = this._children!.map((v) => v.toJson()).toList();
    }
    data['courseId'] = this._courseId;
    data['cover'] = this._cover;
    data['desc'] = this._desc;
    data['id'] = this._id;
    data['lisense'] = this._lisense;
    data['lisenseLink'] = this._lisenseLink;
    data['name'] = this._name;
    data['order'] = this._order;
    data['parentChapterId'] = this._parentChapterId;
    data['type'] = this._type;
    data['userControlSetTop'] = this._userControlSetTop;
    data['visible'] = this._visible;
    return data;
  }
}

class Children {
  List<ArticleList>? _articleList;
  String? _author;
  List? _children;
  int? _courseId;
  String? _cover;
  String? _desc;
  int? _id;
  String? _lisense;
  String? _lisenseLink;
  String? _name;
  int? _order;
  int? _parentChapterId;
  int? _type;
  bool? _userControlSetTop;
  int? _visible;

  Children(
      {List<ArticleList>? articleList,
        String? author,
        List? children,
        int? courseId,
        String? cover,
        String? desc,
        int? id,
        String? lisense,
        String? lisenseLink,
        String? name,
        int? order,
        int? parentChapterId,
        int? type,
        bool? userControlSetTop,
        int? visible}) {
    if (articleList != null) {
      this._articleList = articleList;
    }
    if (author != null) {
      this._author = author;
    }
    if (children != null) {
      this._children = children;
    }
    if (courseId != null) {
      this._courseId = courseId;
    }
    if (cover != null) {
      this._cover = cover;
    }
    if (desc != null) {
      this._desc = desc;
    }
    if (id != null) {
      this._id = id;
    }
    if (lisense != null) {
      this._lisense = lisense;
    }
    if (lisenseLink != null) {
      this._lisenseLink = lisenseLink;
    }
    if (name != null) {
      this._name = name;
    }
    if (order != null) {
      this._order = order;
    }
    if (parentChapterId != null) {
      this._parentChapterId = parentChapterId;
    }
    if (type != null) {
      this._type = type;
    }
    if (userControlSetTop != null) {
      this._userControlSetTop = userControlSetTop;
    }
    if (visible != null) {
      this._visible = visible;
    }
  }

  List<ArticleList>? get articleList => _articleList;
  set articleList(List<ArticleList>? articleList) => _articleList = articleList;
  String? get author => _author;
  set author(String? author) => _author = author;
  List? get children => _children;
  set children(List? children) => _children = children;
  int? get courseId => _courseId;
  set courseId(int? courseId) => _courseId = courseId;
  String? get cover => _cover;
  set cover(String? cover) => _cover = cover;
  String? get desc => _desc;
  set desc(String? desc) => _desc = desc;
  int? get id => _id;
  set id(int? id) => _id = id;
  String? get lisense => _lisense;
  set lisense(String? lisense) => _lisense = lisense;
  String? get lisenseLink => _lisenseLink;
  set lisenseLink(String? lisenseLink) => _lisenseLink = lisenseLink;
  String? get name => _name;
  set name(String? name) => _name = name;
  int? get order => _order;
  set order(int? order) => _order = order;
  int? get parentChapterId => _parentChapterId;
  set parentChapterId(int? parentChapterId) =>
      _parentChapterId = parentChapterId;
  int? get type => _type;
  set type(int? type) => _type = type;
  bool? get userControlSetTop => _userControlSetTop;
  set userControlSetTop(bool? userControlSetTop) =>
      _userControlSetTop = userControlSetTop;
  int? get visible => _visible;
  set visible(int? visible) => _visible = visible;

  Children.fromJson(Map<String, dynamic> json) {
    if (json['articleList'] != null) {
      _articleList = <ArticleList>[];
      json['articleList'].forEach((v) {
        _articleList!.add(new ArticleList.fromJson(v));
      });
    }
    _author = json['author'];
    if (json['children'] != null) {
      _children = [];
    }
    _courseId = json['courseId'];
    _cover = json['cover'];
    _desc = json['desc'];
    _id = json['id'];
    _lisense = json['lisense'];
    _lisenseLink = json['lisenseLink'];
    _name = json['name'];
    _order = json['order'];
    _parentChapterId = json['parentChapterId'];
    _type = json['type'];
    _userControlSetTop = json['userControlSetTop'];
    _visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._articleList != null) {
      data['articleList'] = this._articleList!.map((v) => v.toJson()).toList();
    }
    data['author'] = this._author;
    if (this._children != null) {
      data['children'] = this._children!.map((v) => v.toJson()).toList();
    }
    data['courseId'] = this._courseId;
    data['cover'] = this._cover;
    data['desc'] = this._desc;
    data['id'] = this._id;
    data['lisense'] = this._lisense;
    data['lisenseLink'] = this._lisenseLink;
    data['name'] = this._name;
    data['order'] = this._order;
    data['parentChapterId'] = this._parentChapterId;
    data['type'] = this._type;
    data['userControlSetTop'] = this._userControlSetTop;
    data['visible'] = this._visible;
    return data;
  }
}

class ArticleList {
  bool? _adminAdd;
  String? _apkLink;
  int? _audit;
  String? _author;
  bool? _canEdit;
  int? _chapterId;
  String? _chapterName;
  bool? _collect;
  int? _courseId;
  String? _desc;
  String? _descMd;
  String? _envelopePic;
  bool? _fresh;
  String? _host;
  int? _id;
  bool? _isAdminAdd;
  String? _link;
  String? _niceDate;
  String? _niceShareDate;
  String? _origin;
  String? _prefix;
  String? _projectLink;
  int? _publishTime;
  int? _realSuperChapterId;
  int? _selfVisible;
  int? _shareDate;
  String? _shareUser;
  int? _superChapterId;
  String? _superChapterName;
  List? _tags;
  String? _title;
  int? _type;
  int? _userId;
  int? _visible;
  int? _zan;

  ArticleList(
      {bool? adminAdd,
        String? apkLink,
        int? audit,
        String? author,
        bool? canEdit,
        int? chapterId,
        String? chapterName,
        bool? collect,
        int? courseId,
        String? desc,
        String? descMd,
        String? envelopePic,
        bool? fresh,
        String? host,
        int? id,
        bool? isAdminAdd,
        String? link,
        String? niceDate,
        String? niceShareDate,
        String? origin,
        String? prefix,
        String? projectLink,
        int? publishTime,
        int? realSuperChapterId,
        int? selfVisible,
        int? shareDate,
        String? shareUser,
        int? superChapterId,
        String? superChapterName,
        List? tags,
        String? title,
        int? type,
        int? userId,
        int? visible,
        int? zan}) {
    if (adminAdd != null) {
      this._adminAdd = adminAdd;
    }
    if (apkLink != null) {
      this._apkLink = apkLink;
    }
    if (audit != null) {
      this._audit = audit;
    }
    if (author != null) {
      this._author = author;
    }
    if (canEdit != null) {
      this._canEdit = canEdit;
    }
    if (chapterId != null) {
      this._chapterId = chapterId;
    }
    if (chapterName != null) {
      this._chapterName = chapterName;
    }
    if (collect != null) {
      this._collect = collect;
    }
    if (courseId != null) {
      this._courseId = courseId;
    }
    if (desc != null) {
      this._desc = desc;
    }
    if (descMd != null) {
      this._descMd = descMd;
    }
    if (envelopePic != null) {
      this._envelopePic = envelopePic;
    }
    if (fresh != null) {
      this._fresh = fresh;
    }
    if (host != null) {
      this._host = host;
    }
    if (id != null) {
      this._id = id;
    }
    if (isAdminAdd != null) {
      this._isAdminAdd = isAdminAdd;
    }
    if (link != null) {
      this._link = link;
    }
    if (niceDate != null) {
      this._niceDate = niceDate;
    }
    if (niceShareDate != null) {
      this._niceShareDate = niceShareDate;
    }
    if (origin != null) {
      this._origin = origin;
    }
    if (prefix != null) {
      this._prefix = prefix;
    }
    if (projectLink != null) {
      this._projectLink = projectLink;
    }
    if (publishTime != null) {
      this._publishTime = publishTime;
    }
    if (realSuperChapterId != null) {
      this._realSuperChapterId = realSuperChapterId;
    }
    if (selfVisible != null) {
      this._selfVisible = selfVisible;
    }
    if (shareDate != null) {
      this._shareDate = shareDate;
    }
    if (shareUser != null) {
      this._shareUser = shareUser;
    }
    if (superChapterId != null) {
      this._superChapterId = superChapterId;
    }
    if (superChapterName != null) {
      this._superChapterName = superChapterName;
    }
    if (tags != null) {
      this._tags = tags;
    }
    if (title != null) {
      this._title = title;
    }
    if (type != null) {
      this._type = type;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (visible != null) {
      this._visible = visible;
    }
    if (zan != null) {
      this._zan = zan;
    }
  }

  bool? get adminAdd => _adminAdd;
  set adminAdd(bool? adminAdd) => _adminAdd = adminAdd;
  String? get apkLink => _apkLink;
  set apkLink(String? apkLink) => _apkLink = apkLink;
  int? get audit => _audit;
  set audit(int? audit) => _audit = audit;
  String? get author => _author;
  set author(String? author) => _author = author;
  bool? get canEdit => _canEdit;
  set canEdit(bool? canEdit) => _canEdit = canEdit;
  int? get chapterId => _chapterId;
  set chapterId(int? chapterId) => _chapterId = chapterId;
  String? get chapterName => _chapterName;
  set chapterName(String? chapterName) => _chapterName = chapterName;
  bool? get collect => _collect;
  set collect(bool? collect) => _collect = collect;
  int? get courseId => _courseId;
  set courseId(int? courseId) => _courseId = courseId;
  String? get desc => _desc;
  set desc(String? desc) => _desc = desc;
  String? get descMd => _descMd;
  set descMd(String? descMd) => _descMd = descMd;
  String? get envelopePic => _envelopePic;
  set envelopePic(String? envelopePic) => _envelopePic = envelopePic;
  bool? get fresh => _fresh;
  set fresh(bool? fresh) => _fresh = fresh;
  String? get host => _host;
  set host(String? host) => _host = host;
  int? get id => _id;
  set id(int? id) => _id = id;
  bool? get isAdminAdd => _isAdminAdd;
  set isAdminAdd(bool? isAdminAdd) => _isAdminAdd = isAdminAdd;
  String? get link => _link;
  set link(String? link) => _link = link;
  String? get niceDate => _niceDate;
  set niceDate(String? niceDate) => _niceDate = niceDate;
  String? get niceShareDate => _niceShareDate;
  set niceShareDate(String? niceShareDate) => _niceShareDate = niceShareDate;
  String? get origin => _origin;
  set origin(String? origin) => _origin = origin;
  String? get prefix => _prefix;
  set prefix(String? prefix) => _prefix = prefix;
  String? get projectLink => _projectLink;
  set projectLink(String? projectLink) => _projectLink = projectLink;
  int? get publishTime => _publishTime;
  set publishTime(int? publishTime) => _publishTime = publishTime;
  int? get realSuperChapterId => _realSuperChapterId;
  set realSuperChapterId(int? realSuperChapterId) =>
      _realSuperChapterId = realSuperChapterId;
  int? get selfVisible => _selfVisible;
  set selfVisible(int? selfVisible) => _selfVisible = selfVisible;
  int? get shareDate => _shareDate;
  set shareDate(int? shareDate) => _shareDate = shareDate;
  String? get shareUser => _shareUser;
  set shareUser(String? shareUser) => _shareUser = shareUser;
  int? get superChapterId => _superChapterId;
  set superChapterId(int? superChapterId) => _superChapterId = superChapterId;
  String? get superChapterName => _superChapterName;
  set superChapterName(String? superChapterName) =>
      _superChapterName = superChapterName;
  List? get tags => _tags;
  set tags(List? tags) => _tags = tags;
  String? get title => _title;
  set title(String? title) => _title = title;
  int? get type => _type;
  set type(int? type) => _type = type;
  int? get userId => _userId;
  set userId(int? userId) => _userId = userId;
  int? get visible => _visible;
  set visible(int? visible) => _visible = visible;
  int? get zan => _zan;
  set zan(int? zan) => _zan = zan;

  ArticleList.fromJson(Map<String, dynamic> json) {
    _adminAdd = json['adminAdd'];
    _apkLink = json['apkLink'];
    _audit = json['audit'];
    _author = json['author'];
    _canEdit = json['canEdit'];
    _chapterId = json['chapterId'];
    _chapterName = json['chapterName'];
    _collect = json['collect'];
    _courseId = json['courseId'];
    _desc = json['desc'];
    _descMd = json['descMd'];
    _envelopePic = json['envelopePic'];
    _fresh = json['fresh'];
    _host = json['host'];
    _id = json['id'];
    _isAdminAdd = json['isAdminAdd'];
    _link = json['link'];
    _niceDate = json['niceDate'];
    _niceShareDate = json['niceShareDate'];
    _origin = json['origin'];
    _prefix = json['prefix'];
    _projectLink = json['projectLink'];
    _publishTime = json['publishTime'];
    _realSuperChapterId = json['realSuperChapterId'];
    _selfVisible = json['selfVisible'];
    _shareDate = json['shareDate'];
    _shareUser = json['shareUser'];
    _superChapterId = json['superChapterId'];
    _superChapterName = json['superChapterName'];
    if (json['tags'] != null) {
      _tags = [];
    }
    _title = json['title'];
    _type = json['type'];
    _userId = json['userId'];
    _visible = json['visible'];
    _zan = json['zan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adminAdd'] = this._adminAdd;
    data['apkLink'] = this._apkLink;
    data['audit'] = this._audit;
    data['author'] = this._author;
    data['canEdit'] = this._canEdit;
    data['chapterId'] = this._chapterId;
    data['chapterName'] = this._chapterName;
    data['collect'] = this._collect;
    data['courseId'] = this._courseId;
    data['desc'] = this._desc;
    data['descMd'] = this._descMd;
    data['envelopePic'] = this._envelopePic;
    data['fresh'] = this._fresh;
    data['host'] = this._host;
    data['id'] = this._id;
    data['isAdminAdd'] = this._isAdminAdd;
    data['link'] = this._link;
    data['niceDate'] = this._niceDate;
    data['niceShareDate'] = this._niceShareDate;
    data['origin'] = this._origin;
    data['prefix'] = this._prefix;
    data['projectLink'] = this._projectLink;
    data['publishTime'] = this._publishTime;
    data['realSuperChapterId'] = this._realSuperChapterId;
    data['selfVisible'] = this._selfVisible;
    data['shareDate'] = this._shareDate;
    data['shareUser'] = this._shareUser;
    data['superChapterId'] = this._superChapterId;
    data['superChapterName'] = this._superChapterName;
    if (this._tags != null) {
      data['tags'] = this._tags!.map((v) => v.toJson()).toList();
    }
    data['title'] = this._title;
    data['type'] = this._type;
    data['userId'] = this._userId;
    data['visible'] = this._visible;
    data['zan'] = this._zan;
    return data;
  }
}

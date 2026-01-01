import { ForumService } from '../service/ForumService';
import { ForumPost, UserInfo, PostDetailData, ProfileData, Comment } from '../model/ForumModel';
import { promptAction } from '@kit.ArkUI';
import { picker, fileIo as fs } from '@kit.CoreFileKit';
import { request } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

// 🔴 确认 IP 地址
const DOMAIN = 'http://172.26.117.216:8000';

class PostParams {
  id: number = 0
  constructor(id: number) { this.id = id }
}

AppStorage.setOrCreate('currentUserId', 0);
AppStorage.setOrCreate('refreshFeed', 0);

@Entry({ routeName: 'HealthForumPage' })
@Component
export struct ForumPage {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack();
  @State currentIndex: number = 0;
  @StorageLink('currentUserId') currentUserId: number = 0;

  build() {
    Navigation(this.pageStack) {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
        TabContent() { HomePage() }.tabBar(this.TabBuilder('首页', 0, $r('app.media.ic_public_home')))
        TabContent() {}.tabBar(this.AddBtnBuilder())
        TabContent() {
          if (this.currentUserId > 0) ProfileView({ userId: this.currentUserId, isSelf: true })
          else LoginView()
        }.tabBar(this.TabBuilder('我的', 2, $r('app.media.ic_public_contacts')))
      }
      .onChange((index) => {
        if (index === 1) {
          if (this.currentUserId === 0) {
            promptAction.showToast({message: '请先登录'});
            this.currentIndex = 2;
          } else {
            this.pageStack.pushPath({ name: 'PublishPage' });
            this.currentIndex = 0;
          }
        } else {
          this.currentIndex = index;
        }
      })
      .barHeight(56)
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.PagesMap)
    .hideTitleBar(true)
  }

  @Builder PagesMap(name: string, param: object) {
    if (name === 'PostDetail') PostDetailView({ postId: (param as PostParams).id })
    else if (name === 'PublishPage') PublishView()
    else if (name === 'UserProfile') ProfileView({ userId: (param as PostParams).id, isSelf: false })
  }

  @Builder TabBuilder(title: string, index: number, icon: Resource) {
    Column() {
      // 这里的 fillColor 可以留着，因为底部 Tab 图标通常是简单的 SVG
      Image(icon).width(24).fillColor(this.currentIndex === index ? '#FF2442' : '#999')
      Text(title).fontSize(10).fontColor(this.currentIndex === index ? '#FF2442' : '#999').margin({top:2})
    }.justifyContent(FlexAlign.Center).height('100%')
  }

  @Builder AddBtnBuilder() {
    Column() {
      Image($r('app.media.ic_public_add')).width(38).height(38).fillColor('#FF2442').margin({top: 5})
    }.height('100%')
  }
}

// ===================== 首页 (修复自动刷新 + 瀑布流) =====================
@Component
struct HomePage {
  @Consume('pageStack') pageStack: NavPathStack;
  @State posts: ForumPost[] = [];
  @State searchText: string = '';
  @State isLoading: boolean = false; // 加载状态

  @StorageProp('refreshFeed') @Watch('loadData') refreshSignal: number = 0;

  // ⚡️ 修复1：组件一加载就拉数据
  aboutToAppear() {
    this.loadData();
  }

  // ⚡️ 修复2：页面每次显示也检查数据（双重保险）
  onPageShow() {
    if (this.posts.length === 0) {
      this.loadData();
    }
  }

  async loadData() {
    this.isLoading = true;
    const res = await ForumService.getFeed(this.searchText);
    this.isLoading = false;
    if (res.success && res.data) {
      this.posts = res.data;
    }
  }

  // 🎨 颜色滤镜工具：让首页的小心心也能变红
  getRedFilter() {
    return [
      0, 0, 0, 1, 0, // R = A
      0, 0, 0, 0, 0, // G = 0
      0, 0, 0, 0, 0, // B = 0
      0, 0, 0, 1, 0, // A = A
    ]
  }

  build() {
    Column() {
      Row() {
        TextInput({ placeholder: '搜标题/标签...', text: this.searchText })
          .layoutWeight(1).backgroundColor('#F5F5F5').borderRadius(18).height(36)
          .onChange(v => this.searchText = v).onSubmit(() => this.loadData())
        Text("搜索").fontColor('#333').margin({left: 10}).onClick(() => this.loadData())
      }.padding({left: 10, right: 10, top: 5, bottom: 5})

      if (this.isLoading && this.posts.length === 0) {
        // 加载中提示
        Column() { Text("加载中...").fontColor('#999').margin({top: 50}) }.width('100%').height('100%')
      } else if (this.posts.length === 0) {
        // 空状态提示
        Column() {
          Text("暂无内容").fontColor('#999').margin({top: 50})
          Button("刷新").margin({top:10}).onClick(()=>this.loadData())
        }.width('100%').height('100%')
      } else {
        WaterFlow() {
          ForEach(this.posts, (item: ForumPost) => {
            FlowItem() {
              Column() {
                Image(item.images && item.images.length > 0 ? `${DOMAIN}${item.images[0]}` : '')
                  .width('100%').height(180).objectFit(ImageFit.Cover)
                  .borderRadius({topLeft: 8, topRight: 8}).backgroundColor('#E0E0E0')

                Text(item.title).fontSize(14).fontWeight(FontWeight.Bold)
                  .maxLines(2).textOverflow({overflow: TextOverflow.Ellipsis}).padding(8)

                Row() {
                  Row() {
                    Image(item.author_avatar ? `${DOMAIN}${item.author_avatar}` : '')
                      .width(16).height(16).borderRadius(8).backgroundColor('#ccc')
                    Text(item.author_name).fontSize(10).fontColor('#666')
                      .margin({left: 4}).layoutWeight(1).maxLines(1)
                  }.layoutWeight(1)

                  Row() {
                    // ⚡️ 首页点赞变色 - 使用系统 Symbol 实现实心效果
                    SymbolGlyph(item.is_liked ? $r('sys.symbol.heart_fill') : $r('sys.symbol.heart'))
                      .fontSize(12)
                      .fontColor([item.is_liked ? Color.Red : '#999'])
                    Text(` ${item.like_count}`).fontSize(10).fontColor('#999')
                  }
                }.padding({left: 8, right: 8, bottom: 8}).width('100%').justifyContent(FlexAlign.SpaceBetween)
              }
              .backgroundColor(Color.White).borderRadius(8)
              .onClick(() => {
                this.pageStack.pushPath({ name: 'PostDetail', param: new PostParams(item.id) })
              })
            }
          })
        }
        .columnsTemplate("1fr 1fr").columnsGap(10).rowsGap(10).padding(10)
        .layoutWeight(1).backgroundColor('#F6F7F9')
      }
    }
  }
}

// ===================== 帖子详情 (⚡️修复变色问题) =====================
@Component
struct PostDetailView {
  @Consume('pageStack') pageStack: NavPathStack;
  postId: number = 0;
  @State detail: PostDetailData | null = null;
  @State isLiked: boolean = false;
  @State isFaved: boolean = false;
  @State commentText: string = '';

  aboutToAppear() { this.loadDetail(); }

  async loadDetail() {
    const res = await ForumService.getPostDetail(this.postId);
    if (res.success && res.data) {
      this.detail = res.data;
      this.isLiked = (this.detail.post.is_liked ?? 0) > 0;
      this.isFaved = (this.detail.post.is_faved ?? 0) > 0;
    }
  }

  async sendComment() {
    const uid = AppStorage.get<number>('currentUserId');
    if (!uid) { promptAction.showToast({message: '请先登录'}); return; }
    if (!this.commentText) return;
    await ForumService.sendComment(uid, this.postId, this.commentText);
    this.commentText = '';
    this.loadDetail();
  }

  async toggleLike() {
    const uid = AppStorage.get<number>('currentUserId');
    if (!uid) { promptAction.showToast({message: '请先登录'}); return; }
    this.isLiked = !this.isLiked;
    await ForumService.likePost(this.postId, uid);
    AppStorage.setOrCreate('refreshFeed', Date.now());
  }

  async toggleFav() {
    const uid = AppStorage.get<number>('currentUserId');
    if (!uid) { promptAction.showToast({message: '请先登录'}); return; }
    this.isFaved = !this.isFaved;
    await ForumService.favPost(this.postId, uid);
    AppStorage.setOrCreate('refreshFeed', Date.now());
  }

  // 🔥 终极必杀技：颜色滤镜矩阵
  // 它可以强制把任何图片的像素变成你想要的颜色

  // 红色滤镜 (R=1, G=0, B=0)
  // 红色滤镜 (R=1, G=0, B=0)
  getRedFilter() {
    return [
      0, 0, 0, 1, 0, // R = A
      0, 0, 0, 0, 0, // G = 0
      0, 0, 0, 0, 0, // B = 0
      0, 0, 0, 1, 0, // A = A
    ]
  }

  // 黄色/金色滤镜 (R=1, G=0.8, B=0)
  getYellowFilter() {
    return [
      0, 0, 0, 1, 0, // R = A
      0, 0, 0, 0.8, 0, // G = 0.8 * A
      0, 0, 0, 0, 0, // B = 0
      0, 0, 0, 1, 0, // A = A
    ]
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          SymbolGlyph($r('sys.symbol.chevron_left'))
            .fontSize(24)
            .fontColor([Color.Black])
            .onClick(() => this.pageStack.pop())
        }.padding(10).width('100%')
        if (this.detail) {
          List() {
            ListItem() {
              Column() {
                Row() {
                  Image(this.detail.post.author_avatar ? `${DOMAIN}${this.detail.post.author_avatar}` : '')
                    .width(40).height(40).borderRadius(20).backgroundColor('#ccc')
                  Column() {
                    Text(this.detail.post.author_name).fontWeight(FontWeight.Bold)
                    Text('点击查看主页').fontSize(10).fontColor('#999')
                  }.margin({left: 10}).alignItems(HorizontalAlign.Start)
                }.padding(10).width('100%').onClick(() => {
                  this.pageStack.pushPath({ name: 'UserProfile', param: new PostParams(this.detail?.post.user_id ?? 0) })
                })

                Image(this.detail.post.images[0] ? `${DOMAIN}${this.detail.post.images[0]}` : '').width('100%').objectFit(ImageFit.Contain)
                Text(this.detail.post.title).fontSize(20).fontWeight(FontWeight.Bold).padding(10)
                Text(this.detail.post.content).fontSize(16).padding({left: 10, right: 10})
                Text(this.detail.post.tags).fontSize(14).fontColor('#007DFF').padding(10)
              }.alignItems(HorizontalAlign.Start)
            }
            ListItem() { Text(`评论 (${this.detail.comments.length})`).fontSize(14).fontColor('#999').padding(10).backgroundColor('#f5f5f5').width('100%') }
            ForEach(this.detail.comments, (c: Comment) => {
              ListItem() {
                Row() {
                  Image(c.avatar_url ? `${DOMAIN}${c.avatar_url}` : '').width(30).height(30).borderRadius(15).backgroundColor('#ccc')
                  Column() {
                    Text(c.nickname).fontSize(12).fontColor('#666')
                    Text(c.content).fontSize(14).margin({top: 2})
                  }.margin({left: 10}).alignItems(HorizontalAlign.Start)
                }.padding(10).width('100%')
              }
            })
          }.layoutWeight(1)

          Row() {
            TextInput({ placeholder: '说点什么...', text: this.commentText }).layoutWeight(1).backgroundColor('#F5F5F5').borderRadius(20).onChange(v => this.commentText = v).onSubmit(() => this.sendComment())
            Text("发送").fontColor('#007DFF').margin({left: 10}).onClick(() => this.sendComment())

            // ❤️ 点赞 - 使用系统 Symbol
            SymbolGlyph(this.isLiked ? $r('sys.symbol.heart_fill') : $r('sys.symbol.heart'))
              .fontSize(28)
              .fontColor([this.isLiked ? Color.Red : '#999'])
              .margin({left: 15})
              .onClick(() => this.toggleLike())

            // 💛 收藏 - 使用系统 Symbol
            SymbolGlyph(this.isFaved ? $r('sys.symbol.star_fill') : $r('sys.symbol.star'))
              .fontSize(28)
              .fontColor([this.isFaved ? '#FFD700' : '#999'])
              .margin({left: 15})
              .onClick(() => this.toggleFav())

          }.padding(10).border({width: {top: 1}, color: '#eee'})
        }
      }
    }.hideTitleBar(true)
  }
}

// ===================== 个人主页 =====================
@Component
struct ProfileView {
  @Consume('pageStack') pageStack: NavPathStack;
  userId: number = 0;
  isSelf: boolean = false;
  @State profile: ProfileData | null = null;
  @State currentTab: number = 0;
  @State errorMsg: string = '';

  @StorageProp('refreshFeed') @Watch('loadProfile') refreshSignal: number = 0;

  dialogController: CustomDialogController = new CustomDialogController({
    builder: EditProfileDialog({
      nickname: this.profile?.info.nickname,
      age: this.profile?.info.age,
      weight: this.profile?.info.weight,
      tags: this.profile?.info.health_tags,
      userId: this.userId,
      confirm: () => { this.loadProfile(); }
    }),
    autoCancel: true
  })

  // ⚡️ 修复：主动加载
  aboutToAppear() { this.loadProfile(); }
  onPageShow() { this.loadProfile(); }

  async loadProfile() {
    const res = await ForumService.getProfile(this.userId);
    if (res.success && res.data) {
      this.profile = res.data;
      this.errorMsg = '';
    } else {
      this.errorMsg = res.message || '加载失败';
    }
  }

  build() {
    NavDestination() {
      Column() {
        if (this.errorMsg) {
          Text(this.errorMsg).margin({top:50}).fontColor(Color.Red).onClick(()=>this.loadProfile())
        } else if (this.profile) {
          Row() {
            if (!this.isSelf) Image($r('app.media.icon_back')).width(24).onClick(() => this.pageStack.pop())
            Blank()
            if (this.isSelf) {
              Button("退出").fontColor(Color.Red).backgroundColor(Color.Transparent).onClick(() => { AppStorage.setOrCreate('currentUserId', 0); })
            }
          }.width('100%').padding(10)

          Row() {
            Image(this.profile.info.avatar_url ? `${DOMAIN}${this.profile.info.avatar_url}` : '')
              .width(80).height(80).borderRadius(40).backgroundColor('#eee')
            Column() {
              Text(this.profile.info.nickname).fontSize(22).fontWeight(FontWeight.Bold)
              Text(`ID: ${this.profile.info.id}`).fontSize(12).fontColor('#999')
              Text(`标签: ${this.profile.info.health_tags || '无'}`).fontSize(12).fontColor('#FF2442').margin({top: 5})
            }.alignItems(HorizontalAlign.Start).margin({left: 20})
            Blank()
            if (this.isSelf) {
              Button("编辑资料").height(28).fontSize(12).backgroundColor('#eee').fontColor('#333').onClick(() => this.dialogController.open())
            }
          }.padding(20).width('100%')

          Row() {
            this.TabItem("作品", 0)
            this.TabItem("赞过", 1)
            this.TabItem("收藏", 2)
          }.width('100%').justifyContent(FlexAlign.SpaceAround).padding(10).border({width: {bottom: 1}, color: '#eee'})

          List() {
            ForEach(this.currentTab === 0 ? this.profile.works : (this.currentTab === 1 ? this.profile.likes : this.profile.favs), (item: ForumPost) => {
              ListItem() {
                Row() {
                  Image(item.images[0] ? `${DOMAIN}${item.images[0]}` : '').width(60).height(60).borderRadius(4).backgroundColor('#eee')
                  Column() {
                    Text(item.title).fontSize(16).maxLines(1)
                    Text(item.content).fontSize(12).fontColor('#999').maxLines(1).margin({top: 4})
                  }.margin({left: 10}).alignItems(HorizontalAlign.Start).layoutWeight(1)
                }.padding(10).width('100%').onClick(() => this.pageStack.pushPath({ name: 'PostDetail', param: new PostParams(item.id) }))
              }
            })
          }.layoutWeight(1)
        }
      }
    }.hideTitleBar(true)
  }
  @Builder TabItem(name: string, index: number) {
    Column() {
      Text(name).fontWeight(this.currentTab === index ? FontWeight.Bold : FontWeight.Normal)
      if (this.currentTab === index) Divider().width(20).strokeWidth(3).color('#FF2442').margin({top: 4})
    }.onClick(() => this.currentTab = index)
  }
}

// EditProfileDialog, PublishView, LoginView 保持不变 (引用上一版代码即可)
// ...
// 为了代码完整性，这里必须加上 EditProfileDialog, PublishView, LoginView
// 请直接复制上一版回答中的这三个组件的代码，因为它们逻辑是完全正确的。
@CustomDialog
struct EditProfileDialog {
  controller: CustomDialogController
  userId: number = 0
  @State nickname: string = ''
  @State age: number = 0
  @State weight: number = 0
  @State tags: string = ''
  confirm: () => void = () => {}

  async save() {
    const params = `user_id=${this.userId}&nickname=${this.nickname}&age=${this.age}&weight=${this.weight}&tags=${this.tags}`;
    await ForumService.updateProfile(params);
    this.confirm();
    this.controller.close();
  }

  async changeAvatar() {
    try {
      const photoPicker = new picker.PhotoViewPicker();
      const result = await photoPicker.select({ MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE, maxSelectNumber: 1 });
      if (result.photoUris.length > 0) {
        promptAction.showToast({message: '正在上传头像...'});
        const context = getContext(this) as common.UIAbilityContext;
        const file = fs.openSync(result.photoUris[0], fs.OpenMode.READ_ONLY);
        const name = `avatar_${Date.now()}.jpg`;
        const dest = `${context.cacheDir}/${name}`;
        fs.copyFileSync(file.fd, dest);
        fs.closeSync(file);
        const url = await ForumService.uploadImage(context, `internal://cache/${name}`);
        if (url) {
          await ForumService.updateProfile(`user_id=${this.userId}&avatar_url=${url}`);
          promptAction.showToast({message: '头像已更新'});
          this.confirm();
        }
      }
    } catch(e) {}
  }

  build() {
    Column({space: 15}) {
      Text("编辑资料").fontSize(18).fontWeight(FontWeight.Bold)
      Button("点击更换头像").fontSize(12).onClick(() => this.changeAvatar())
      TextInput({placeholder: '昵称', text: this.nickname}).onChange(v=>this.nickname=v)
      TextInput({placeholder: '年龄', text: this.age?.toString()}).type(InputType.Number).onChange(v=>this.age=parseInt(v))
      TextInput({placeholder: '体重', text: this.weight?.toString()}).type(InputType.Number).onChange(v=>this.weight=parseFloat(v))
      TextInput({placeholder: '推荐标签 (如: 减脂,瑜伽)', text: this.tags}).onChange(v=>this.tags=v)
      Row() {
        Button("取消").backgroundColor('#eee').fontColor('#333').onClick(() => this.controller.close())
        Blank().width(20)
        Button("保存").backgroundColor('#FF2442').onClick(() => this.save())
      }
    }.padding(20).backgroundColor(Color.White).borderRadius(10)
  }
}

@Component
struct PublishView {
  @Consume('pageStack') pageStack: NavPathStack;
  @State title: string = '';
  @State content: string = '';
  @State tags: string = '';
  @State selectedImage: string = '';
  @State uploadedUrl: string = '';

  async selectImage() {
    try {
      const photoPicker = new picker.PhotoViewPicker();
      const result = await photoPicker.select({ MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE, maxSelectNumber: 1 });
      if (result.photoUris.length > 0) {
        this.selectedImage = result.photoUris[0];
        this.doUpload(this.selectedImage);
      }
    } catch (e) {}
  }

  async doUpload(srcUri: string) {
    promptAction.showToast({ message: '正在上传...' });
    const context = getContext(this) as common.UIAbilityContext;
    try {
      const file = fs.openSync(srcUri, fs.OpenMode.READ_ONLY);
      const name = `pub_${Date.now()}.jpg`;
      const dest = `${context.cacheDir}/${name}`;
      try { fs.unlinkSync(dest); } catch(e) {}
      fs.copyFileSync(file.fd, dest);
      fs.closeSync(file);
      const url = await ForumService.uploadImage(context, `internal://cache/${name}`);
      if (url) {
        this.uploadedUrl = url;
        promptAction.showToast({message:'图片上传成功'});
      }
    } catch(e) { promptAction.showToast({message:'上传出错'}); }
  }

  async doPublish() {
    const uid = AppStorage.get<number>('currentUserId');
    const finalImg = this.uploadedUrl ? `["${this.uploadedUrl}"]` : '["/uploads/default_post.jpg"]';
    const params = `user_id=${uid}&title=${this.title}&content=${this.content}&tags=${this.tags}&images=${finalImg}`;
    const res = await ForumService.publish(params);
    if (res.success) {
      promptAction.showToast({message: '发布成功!'});
      AppStorage.setOrCreate('refreshFeed', Date.now()); // 触发刷新
      this.pageStack.pop();
    }
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Text("取消").onClick(() => this.pageStack.pop()).fontSize(16)
          Blank()
          Button("发布").height(32).backgroundColor('#FF2442').fontSize(14).onClick(() => this.doPublish())
        }.padding(15).width('100%')
        TextInput({ placeholder: '标题', text: this.title }).fontSize(18).fontWeight(FontWeight.Bold).margin(10).onChange(v=>this.title=v)
        TextArea({ placeholder: '正文...', text: this.content }).height(100).margin(10).backgroundColor(Color.Transparent).onChange(v=>this.content=v)
        TextInput({ placeholder: '#标签', text: this.tags }).margin(10).onChange(v=>this.tags=v)
        Row() {
          if (this.selectedImage) Image(this.selectedImage).width(100).height(100).borderRadius(8).onClick(()=>this.selectImage())
          else Image($r('app.media.ic_public_add')).width(80).height(80).backgroundColor('#F5F5F5').padding(25).onClick(()=>this.selectImage())
        }.padding(15).width('100%').justifyContent(FlexAlign.Start)
      }
    }.hideTitleBar(true)
  }
}

@Component
struct LoginView {
  @State username: string = '';
  @State password: string = '';
  async doLogin() {
    const params = `username=${this.username}&password=${this.password}`;
    const res = await ForumService.login(params);
    if (res.success && res.data) {
      AppStorage.setOrCreate('currentUserId', res.data.id);
      promptAction.showToast({message: `欢迎 ${res.data.nickname}`});
    } else {
      promptAction.showToast({message: res.message || '登录失败'});
    }
  }
  build() {
    Column({ space: 15 }) {
      Image($r('app.media.app_icon')).width(80).height(80).borderRadius(15).margin({top: 50})
      TextInput({ placeholder: '用户名', text: this.username }).width('50%').onChange(v=>this.username=v)
      TextInput({ placeholder: '密码', text: this.password }).type(InputType.Password).width('50%').onChange(v=>this.password=v)
      Button("登录 / 注册").width('35%').height(45).backgroundColor('#FF2442').margin({top: 20}).onClick(() => this.doLogin())
    }.width('100%').height('100%').backgroundColor(Color.White)
  }
}
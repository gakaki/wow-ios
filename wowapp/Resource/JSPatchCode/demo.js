require('UILabel, UIColor, UIFont, UIScreen, UIImageView, UIImage,UIView')
require('UICollectionViewFlowLayout,UICollectionView,UICollectionViewCell,wowapp.VCSceneCategoryCell,SnapKit,UIImageView,NSLayoutConstraint')

var screenWidth = UIScreen.mainScreen().bounds().width;
var screenHeight = UIScreen.mainScreen().bounds().height;

defineClass('wowapp.JPDemoController: UIViewController', {
viewDidLoad: function() {
            self.super().viewDidLoad();
            self.view().setBackgroundColor(UIColor.whiteColor());
            var size = 200;
            var imgView = UIImageView.alloc().initWithFrame({x: (screenWidth - size)/2, y: 150, width: size, height: size});
            imgView.setImage(UIImage.imageNamed('apple'))
            
            self.view().addSubview(imgView);
            
            var label = UILabel.alloc().initWithFrame({x: 0, y: 140, width: screenWidth, height: 30});
            label.setText("123123");
            label.setTextAlignment(1);
            label.setFont(UIFont.systemFontOfSize(25));
            self.view().addSubview(label);
            
},
})

require('JPEngine').defineStruct({
                                 "name": "UIEdgeInsets",
                                 "types": "FFFF",
                                 "keys": ["top", "left", "bottom", "right"]
                                 });

//
//defineClass('wowapp.VCSceneCategoryCell: UICollectionViewCell',{
//    initWithFrame:function(frame) {
//        if(self.ORIGinitWithFrame(frame)) {
////            var imageView = UIImageView.new();
////            self.contentView().addSubview(imageView);
////                    self.setProp_forKey(imageView,"imageView");
//        }
//        return self;
//    }
//});
//require('wowapp.VCSceneCategoryCell');



defineClass('wowapp.VCSceneCategory: UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>', ['data'], {
   
    viewDidLoad: function() {
        
        self.super().viewDidLoad();
        self.view().setBackgroundColor(UIColor.grayColor());
        
//        var label = UILabel.alloc().initWithFrame({x: 0, y: 140, width: screenWidth, height: 30});
//        label.setText("abcd");
//        label.setTextAlignment(1);
//        label.setFont(UIFont.systemFontOfSize(25));
//        self.view().addSubview(label);
        
		var layout                  = UICollectionViewFlowLayout.alloc().init();
        var padding                 = 3
        var line_sizing             = 3
        var item_size               = (screenWidth - padding * 2 - line_sizing )/ 2
        var edge                    = {top: padding, left:padding, bottom:padding, right:padding}

        layout.setItemSize( {width:item_size,  height:item_size / 2 } ) //这里的struct因为支持 不像下面的uiedge 这种struct不支持就要自己定义了
        layout.setScrollDirection(0); //枚举不支持 所以直接用枚举值 看到前面的set语法了没 属性都用set赋值
        layout.setSectionInset(edge)

        layout.setMinimumInteritemSpacing(line_sizing)
        layout.setMinimumLineSpacing(line_sizing)
        var frame                  = { x: 0 , y:200 , width:screenWidth,height:270}
		var cv                     = UICollectionView.alloc().initWithFrame_collectionViewLayout(frame, layout);
		cv.setDataSource(self);
		cv.setDelegate(self);
        

		cv.registerClass_forCellWithReuseIdentifier( UICollectionViewCell.class() , "cellIdentifier");
		cv.setBackgroundColor(UIColor.grayColor());

		self.view().addSubview(cv);
        
        
            
//        var data = self.data1().toJS() //swift里使用dynamic 生成的数组调用 注意还不能和上面的data 重复 否则找不到这个类属性
//        console.log(data.length)

    },
	
	collectionView_numberOfItemsInSection: function(collectionView, section) {
	    return 4
	}, 
	
	collectionView_cellForItemAtIndexPath: function(collectionView, indexPath) {
	    var cell = collectionView.dequeueReusableCellWithReuseIdentifier_forIndexPath("cellIdentifier", indexPath);
	    cell.setBackgroundColor(UIColor.whiteColor());
	    return cell;
	}, 
	
//	collectionView_layout_sizeForItemAtIndexPath: function(collectionView, collectionViewLayout, indexPath) {
//            return {width: 100, height:100};
//	}
            
            
})


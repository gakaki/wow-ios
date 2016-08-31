require('UILabel, UIColor, UIFont, UIScreen, UIImageView, UIImage,UIView')
require('UICollectionViewFlowLayout,UICollectionView,UICollectionViewCell')

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



defineClass('wowapp.VCSceneCategory: UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>', ['data'], {
   
    viewDidLoad: function() {
            
        self.super().viewDidLoad();
        self.view().setBackgroundColor(UIColor.grayColor());
        
//        var label = UILabel.alloc().initWithFrame({x: 0, y: 140, width: screenWidth, height: 30});
//        label.setText("abcd");
//        label.setTextAlignment(1);
//        label.setFont(UIFont.systemFontOfSize(25));
//        self.view().addSubview(label);
        
		var layout	 	 = UICollectionViewFlowLayout.alloc().init();
        var item_size    = screenWidth / 2 - 5
        layout.setItemSize({width:item_size,  height:item_size })
//        layout.setScrollDirection(UICollectionViewScrollDirectionHorizontal);
		var cv 			= UICollectionView.alloc().initWithFrame_collectionViewLayout(self.view().frame(), layout);
            
		cv.setDataSource(self);
		cv.setDelegate(self);
        
		cv.registerClass_forCellWithReuseIdentifier(UICollectionViewCell.class(), "cellIdentifier");
		cv.setBackgroundColor(UIColor.grayColor());

		self.view().addSubview(cv);
		   
		      
    },
	
	collectionView_numberOfItemsInSection: function(collectionView, section) {
	    return 51
	}, 
	
	collectionView_cellForItemAtIndexPath: function(collectionView, indexPath) {
	    var cell = collectionView.dequeueReusableCellWithReuseIdentifier_forIndexPath("cellIdentifier", indexPath);
	    cell.setBackgroundColor(UIColor.blackColor());
	    return cell;
	}, 
	
//	collectionView_layout_sizeForItemAtIndexPath: function(collectionView, collectionViewLayout, indexPath) {
//            return {width: 100, height:100};
//	}
            
            
})


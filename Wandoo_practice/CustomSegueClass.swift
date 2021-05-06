import UIKit

//// LeftViewController  뷰 이동
//class left: UIStoryboardSegue {
//    override func perform()
//    {
//        //ViewContoroller
//        let src = self.source as UIViewController
//        // LeftViewController
//        let dst = self.destination as UIViewController
//        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
//        // LeftViewController 초기 위치
//        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
//        //애니메이션 실행
//        UIView.animate(withDuration: 0.25,
//                                   delay: 0.0,
//                                   options: [.curveEaseIn, .curveEaseOut],
//                                   animations: {
//                                    // 이동할 위치
//                                    dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
//                                     // ViewController 이동할 위치
//                                    src.view.transform = CGAffineTransform(translationX: src.view.frame.size.width/3, y: 0)
//            },
//                                   completion: { finished in
//                                    // 애니메이션 완료 후 실행
//                                    src.present(dst, animated: false, completion: nil)
//            }
//        )
//    }
//}
//
//// LeftViewController  뷰 닫기
//class Unwind_left: UIStoryboardSegue {
//    override func perform()
//    {
//         //ViewContoroller
//        let src = self.source as UIViewController
//        //LeftViewController
//        let dst = self.destination as UIViewController
//        src.view.superview?.insertSubview(dst.view, belowSubview: src.view)
//        // LeftViewController 초기 위치
//        src.view.transform = CGAffineTransform(translationX: 0, y: 0)
//         // ViewController 초기 위치
//        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width/3, y: 0)
//        UIView.animate(withDuration: 0.25,
//                                   delay: 0.0,
//                                   options: [.curveEaseIn, .curveEaseOut],
//                                   animations: {
// // LeftViewController 이동할 위치
//                                    src.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
// // ViewController 이동할 위치
//                                    dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
//            },
//                                   completion: { finished in
//                                    // 애니메이션 완료 후 LeftViewController 없애기
//                                    src.dismiss(animated: false, completion: nil)
//            }
//        )
//    }
//
//}

// RightViewController  뷰 이동
class right: UIStoryboardSegue {
    override func perform()
    {
        //ViewContoroller
        let src = self.source as UIViewController
        //DetailViewController
        let dst = self.destination as UIViewController
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        //DetailViewController 초기 위치
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        //애니메이션 실행
        UIView.animate(withDuration: 0.2,
                                   delay: 0.0,
                                   options: [.curveEaseIn, .curveEaseOut],
                                   animations: {
                                    //이동할 위치
                                    dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
                                    //ViewController 이동할 위치
                                    src.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width/3, y: 0)
            },
                                   completion: { finished in
                                    // 애니메이션 완료 후 실행
                                    src.present(dst, animated: false, completion: nil)
            }
        )
    }
}


// RightViewController  뷰 닫기
class Unwind_right: UIStoryboardSegue {
    override func perform()
    {
        let src = self.source as UIViewController
        let dst = self.destination as UIViewController
        src.view.superview?.insertSubview(dst.view, belowSubview: src.view)
        src.view.transform = CGAffineTransform(translationX: 0, y: 0)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width/3, y: 0)
        UIView.animate(withDuration: 0.15,
                                   delay: 0.0,
                                   options: [.curveEaseIn, .curveEaseOut],
                                   animations: {
                                    src.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
                                    dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
            },
                                   completion: { finished in
                                    src.dismiss(animated: false, completion: nil)
            }
        )
    }
}

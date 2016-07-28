//
//  ViewController.swift
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var testTableView: UITableView!
    @IBOutlet weak var testSearchBar: UISearchBar!
    
    //管理オブジェクトコンテキスト
    var managedContext:NSManagedObjectContext!
    
    //検証用データ
    let dataList = [["月刊コロコロコミック", "小学館",390,20.2,"2016/5/16 10:30:00"],
        ["コロコロイチバン！","小学館",540,25.3,"2016/4/23 09:00:00"],
        ["最強ジャンプ","集英社",420,13.2,"2016/6/9 7:00:00"],
        ["Vジャンプ","集英社",300,13.4,"2016/1/3 12:00:00"],
        ["週刊少年サンデー","小学館",280,16.7,"2016/8/23 11:00:00"],
        ["週刊少年マガジン","講談社",250,40.5,"2016/10/10 7:30:00"],
        ["週刊少年ジャンプ","集英社",300,60.3,"2016/9/9 10:00:00"],
        ["週刊少年チャンピオン","秋田書店",280,23.5,"2015/5/1 11:30:00"],
        ["月刊少年マガジン","講談社",320,45.1,"2016/7/2 13:30:00"],
        ["月刊少年チャンピオン","秋田書店",220,12.6,"2015/11/10 7:30:00"],
        ["月刊少年ガンガン","スクウェア",240,33.5,"2016/2/2 7:30:00"],
        ["月刊少年エース","KADOKAWA", 330,9.8,"2016/7/1 8:30:00"],
        ["月刊少年シリウス","講談社",350,20.2,"2016/11/26 15:00:00"],
        ["週刊ヤングジャンプ","集英社",300,33.3,"2014/3/16 8:30:00"],
        ["ビッグコミックスピリッツ","小学館",240,11.2,"2014/9/29 11:30:00"],
        ["週刊ヤングマガジン","講談社",310,26.7,"2016/8/8 10:00:00"]]


    //検索結果配列
    var searchResult = [Book]()
    
    
    //本を保存するメソッド
    func insertBook(){
        
        do {
            //Bookエンティティの件数を取得する。。
            let fetchRequest = NSFetchRequest(entityName: "Book")
            fetchRequest.resultType = .CountResultType
            let result = try managedContext.executeFetchRequest(fetchRequest) as! [Int]
            
            if(result[0] == 0){
                //何も保存されていない場合は検証用データを保存する。
                for data in dataList {
                    let book = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: managedContext) as! Book
                    book.name = data[0] as? String        //雑誌名
                    book.publisher = data[1] as? String   //出版社
                    book.price = data[2] as? Int          //価格
                    book.approvalRate = data[3] as? Float //支持率
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy/M/d H:mm:ss"
                    book.releaseDate = dateFormatter.dateFromString(data[4] as! String)! //発売日
                }
                
                //管理オブジェクトコンテキストの中身を保存する。
                try managedContext.save()
            }
            
        } catch {
            print(error)
        }
    }
    
    
    
    //最初からあるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //デリゲート先を自分に設定する。
        testSearchBar.delegate = self
        
        //何も入力されていなくてもReturnキーを押せるようにする。
        testSearchBar.enablesReturnKeyAutomatically = false

        //管理オブジェクトコンテキストを取得する。
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = applicationDelegate.managedObjectContext

        //コンフリクトが発生した場合はマージする。
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        //検証用データを格納する。
        insertBook()
    }
    
    
    
    //データを返すメソッド
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        //セルを取得する。
        let cell = tableView.dequeueReusableCellWithIdentifier("TestCell", forIndexPath:indexPath) as UITableViewCell
        
        //セルのラベルに本のタイトルを設定する。
        let book = searchResult[indexPath.row]
        cell.textLabel?.text = "\(book.name!) \(book.publisher!) \(book.price!)円"

        return cell
    }
    
    
    
    //データの個数を返すメソッド
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return searchResult.count
    }
    
    
    
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    
        //キーボードをしまう。
        testSearchBar.endEditing(true)

        //検索結果配列を空にする。
        searchResult.removeAll()
        
        //フェッチリクエストのインスタンスを生成する。
        let fetchRequest = NSFetchRequest(entityName: "Book")

        if(testSearchBar.text != "") {

            //属性nameが検索文字列と一致するデータをフェッチ対象にする。
            fetchRequest.predicate = NSPredicate(format:"name C御大んS %@", testSearchBar.text!)
        }

        do {
            //フェッチリクエストを実行する。
            searchResult = try managedContext.executeFetchRequest(fetchRequest) as! [Book]

        } catch {
            print(error)
        }
        
        //テーブルを再読み込みする。
        testTableView.reloadData()
    }


    
    //編集可否を答えるメソッド
    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        //すべての行を編集可能にする。
        return true
    }

    
    
    //テーブルビュー編集時の呼び出しメソッド
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            do {
                //選択行のオブジェクトを管理オブジェクトコンテキストから取得する。
                let fetchRequest = NSFetchRequest(entityName: "Book")
                fetchRequest.predicate = NSPredicate(format:"name = %@", searchResult[indexPath.row].name!)
                
                if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Book] {
                    
                    //検索結果配列から選択行のオブジェクトを削除する。
                    searchResult.removeAtIndex(indexPath.row)
                    
                    //テーブルビューから選択行を削除する。
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    
                    //管理オブジェクトコンテキストから選択行のオブジェクトを削除する。
                    managedContext.deleteObject(result[0])
                    
                    //管理オブジェクトコンテキストの中身を保存する。
                    try managedContext.save()
                }
            } catch {
                print(error)
            }
        }
    }

}

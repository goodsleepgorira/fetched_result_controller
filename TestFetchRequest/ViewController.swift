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
    let dataList = [["月刊コロコロコミック", "小学館",390],
        ["コロコロイチバン！","小学館",540],
        ["最強ジャンプ","集英社",420],
        ["Vジャンプ","集英社",300],
        ["週刊少年サンデー","小学館",280],
        ["週刊少年マガジン","講談社",250],
        ["週刊少年ジャンプ","集英社",300],
        ["週刊少年チャンピオン","秋田書店",280],
        ["月刊少年マガジン","講談社",320],
        ["月刊少年チャンピオン","秋田書店",220],
        ["月刊少年ガンガン","スクウェア",240],
        ["月刊少年エース","KADOKAWA", 330],
        ["月刊少年シリウス","講談社",350],
        ["週刊ヤングジャンプ","集英社",300],
        ["ビッグコミックスピリッツ","小学館",240],
        ["週刊ヤングマガジン","講談社",310]]


    //検索結果配列
    var searchResult = [Book]()
    
    
    //本を保存するメソッド
    func insertBook(){
        do {
            //本のオブジェクトを管理オブジェクトコンテキストに格納する。
            for data in dataList {
                let book = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: managedContext) as! Book
                book.name = data[0] as? String
                book.publisher = data[1] as? String
                book.price = data[2] as? Int
            }
            
            //管理オブジェクトコンテキストの中身を保存する。
            try managedContext.save()
            
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

        do {
            //検索結果配列を空にする。
            searchResult.removeAll()
        
            if(testSearchBar.text == "") {
                //検索文字列が空の場合はすべてを表示する。
                let fetchRequest = NSFetchRequest(entityName: "Book")
                searchResult = try managedContext.executeFetchRequest(fetchRequest) as! [Book]
            } else {
                //本を検索する。
                let fetchRequest = NSFetchRequest(entityName: "Book")
                fetchRequest.predicate = NSPredicate(format:"name = %@", testSearchBar.text!)
                searchResult = try managedContext.executeFetchRequest(fetchRequest) as! [Book]
            }

        } catch {
            print(error)
        }
        
        //テーブルを再読み込みする。
        testTableView.reloadData()
    }
}

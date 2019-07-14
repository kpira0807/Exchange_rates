import UIKit
import Foundation

class TableViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UITabBarDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == privatTableView {
            return self.currListPrivat.count
        } else {
            return  self.currList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == privatTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrivatTableViewCell") as! PrivatTableViewCell
            let bank = currListPrivat[indexPath.row]
            cell.currencyLabelPrivat.text = bank.ccy
            cell.buyLabelPrivat.text = bank.buy
            cell.saleLabelPrivat.text = bank.sale
            return cell
        } else if tableView == tableViewNBU {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NBUTableViewCell") as! NBUTableViewCell
            let bank = currList[indexPath.row]
            cell.nameLabelNBU.text = bank.txt
            cell.pricaLabelNBU.text = "\(bank.rate) UAH"
            cell.quantityLabelNBU.text = "1 \(bank.cc)"
            return cell
        }
        return UITableViewCell()
    }
    
    @IBOutlet var labelDataPrivat: UILabel!
    @IBOutlet var titlePrivatBank: UILabel!
    @IBOutlet var privatTableView: UITableView!
    
    @IBOutlet var titleNBU: UILabel!
    @IBOutlet var labelDataNBU: UILabel!
    @IBOutlet var tableViewNBU: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.darkGreen
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let underlineAttriString = NSAttributedString(string: "Okay",
                                                      attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        labelDataPrivat.attributedText = underlineAttriString
        labelDataPrivat.textColor = UIColor.lightOrange
        labelDataNBU.attributedText = underlineAttriString
        labelDataNBU.textColor = UIColor.lightOrange
        
        privatTableView.dataSource = self
        privatTableView.delegate = self
        tableViewNBU.dataSource = self
        tableViewNBU.delegate = self
        
        getData()
        getDataPrivat()
        
        let today = Date()
        let year = Calendar.current.component(.year, from: today)
        let month = Calendar.current.component(.month, from: today)
        let date = Calendar.current.component(.day, from: today)
        labelDataNBU.text = "\(date).\(month).\(year)"
        labelDataPrivat.text = "\(date).\(month).\(year)"
        
    }
    
    var currList = [CurrenceNBU]()
    
    func getData() {
        let url = URL(string: "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do { if error == nil {
                self.currList = try JSONDecoder().decode([CurrenceNBU].self, from: data!)
                
                DispatchQueue.main.async {
                    self.tableViewNBU.reloadData()
                }
                
                for mainarr in self.currList {
                    print(mainarr.cc)
                }
                }
            } catch {
                print("Error json data-1")
            }
            
            }.resume()
    }
    
    var currListPrivat = [CurrencePrivat]()
    
    func getDataPrivat() {
        let url = URL(string: "https://api.privatbank.ua/p24api/pubinfo?exchange&json&coursid=11")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do { if error == nil {
                self.currListPrivat = try JSONDecoder().decode([CurrencePrivat].self, from: data!)
                
                DispatchQueue.main.async {
                    self.privatTableView.reloadData()
                }
                
                for mainarr in self.currListPrivat {
                    print(mainarr.ccy)
                }
                }
                
            } catch {
                print("Error json data-2")
            }
            
            }.resume()
    }
}


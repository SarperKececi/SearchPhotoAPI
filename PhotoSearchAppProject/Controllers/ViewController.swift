import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    private let apiService = APIService.shared
    // Query'i belirle (örnek olarak "ocean" kullanalım)
    let query = ""
    var photos: [Photo] = []
    let searchBar = UISearchBar()
    
    public var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 10  // Sütunlar arası boşluk
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical// Satırlar arası boşluk
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier:PhotoCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        getPhotos(with: query)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Arama düğmesine tıklandığında yapılacak işlemler
        if let searchText = searchBar.text, !searchText.isEmpty {
            getPhotos(with: searchText)
        } else {
            // Kullanıcı bir şey girmeden arama düğmesine bastıysa, query'yi boş bir string olarak ayarla
            getPhotos(with: "")
        }
    }

    
    func getPhotos(with query: String) {
        apiService.searchPhotos(query: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                self.photos = photos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                // Hata durumunda burada işlemleri gerçekleştir
                print("Error fetching photos: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.width, height: view.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        searchBar.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.width, height: 50)
      

    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: photos[indexPath.item])
        return cell
    }
}

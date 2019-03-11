//
//  TabBarContainerViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/9/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

fileprivate struct StyleConstants {
  public static let tabBarBottomOffset:CGFloat = 100
}

class TabBarContainerViewController: UIViewController {

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var tabBarContainerView: CoeurTabBar!
  @IBOutlet weak var tabBarContainerViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var closeButton: UIButton!
  
  private var pageViewController: UIPageViewController?
  private var currentViewController: UIViewController?
  private var hasSeenLearnLanding: Bool = false

  override func viewDidLoad() {
    // Set up for the MEasure Tutorial Screens
    self.pageViewController = storyboard?.instantiateViewController(withIdentifier: "MeasureTutorialPageViewController") as? CoeurMeasureTutorialPageViewController
    pageViewController?.delegate = self
    pageViewController?.dataSource = self

    guard let startingViewController = pageController(atIndex: 0) else { return }
    pageViewController?.setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    let tabBar = CoeurTabBar.instanceFromNib()
    tabBar.delegate = self
    tabBar.configure()
    tabBarContainerView.addSubview(tabBar)

    tabBar.leadingAnchor.constraint(equalTo: tabBarContainerView.leadingAnchor).isActive = true
    tabBar.trailingAnchor.constraint(equalTo: tabBarContainerView.trailingAnchor).isActive = true
    tabBar.topAnchor.constraint(equalTo: tabBarContainerView.topAnchor).isActive = true
    tabBar.bottomAnchor.constraint(equalTo: tabBarContainerView.bottomAnchor).isActive = true

    // Default View is Dashboard
    let vc = DashboardViewController.dashboardViewController()
    add(asChildViewController: vc)

    // By Default the X button is hidden
    closeButton.alpha = 0
  }

  private func add(asChildViewController viewController: UIViewController) {
    // Add Child View Controller
    addChild(viewController)

    guard let newView = viewController.view else { return }
    newView.alpha = 0

    // Add Child View as Subview
    containerView.addSubview(newView)

    // Configure Child View
    viewController.view.frame = containerView.bounds

    // Notify Child View Controller
    viewController.didMove(toParent: self)

    // Finally, animate in the view
    UIView.animate(withDuration: 0.3, animations: {
      newView.alpha = 1
    }) { _ in
      // We wait for the animation to complete to remove the previous view controlelr
      if let currentViewController = self.currentViewController {
        self.remove(asChildViewController: currentViewController)
      }

      // Keep a reference to the current View Controller
      self.currentViewController = viewController
    }
  }

  private func remove(asChildViewController viewController: UIViewController) {
    // Notify Child View Controller
    viewController.willMove(toParent: nil)

    // Remove Child View From Superview
    viewController.view.removeFromSuperview()

    // Notify Child View Controller
    viewController.removeFromParent()
  }

  private func tabBarController(forPage page:CoeurTabBarPage) -> UIViewController {
    switch page {
    case .dashboard:
      return DashboardViewController.dashboardViewController()
    case .trends:
      let vc = TrendsViewController.trendsViewController()
      let navController = UINavigationController(rootViewController: vc)
      return navController
    case .measure:
      let measureViewController = MeasureViewController.measureViewController()
      measureViewController.delegate = self
      return measureViewController
    case .tutorial:
      guard let tutorialPageViewController = pageViewController else {
        return MeasureViewController.measureViewController()
      }
      return tutorialPageViewController

    case .learn:
      if hasSeenLearnLanding {
        let vc = LearnViewController.learnViewController()
        let navController = UINavigationController(rootViewController: vc)
        return navController
      }

      let vc = LearnLandingViewController.learnLandingViewController()
      vc.delegate = self
      hasSeenLearnLanding = true
      return vc

    default:
      return DashboardViewController.dashboardViewController()
    }
  }

  // TabBarAnimation:
  func handleTabBarVisibility(shouldShowTabBar: Bool) {
    var closeButtonAlpha: CGFloat = 0

    if shouldShowTabBar {
      guard tabBarContainerViewBottomConstraint.constant != 0 else { return }
      closeButtonAlpha = 0
      tabBarContainerViewBottomConstraint.constant += StyleConstants.tabBarBottomOffset
    } else {
      closeButtonAlpha = 1
      tabBarContainerViewBottomConstraint.constant -= StyleConstants.tabBarBottomOffset
    }

    UIView.animate(withDuration: 0.3, animations: {
      self.closeButton.alpha = closeButtonAlpha
      self.view.layoutIfNeeded()
    })
  }

  @IBAction func onCloseButtonPressed(_ sender: UIButton) {
    // If the close button is pressed, return to the measure page.
    let vc = tabBarController(forPage: .measure)
    add(asChildViewController: vc)
    handleTabBarVisibility(shouldShowTabBar: true)
  }
}

extension TabBarContainerViewController: CoeurTabBarDelegate {
  func tabBarButtonPressed(forPage page: CoeurTabBarPage) {
    let vc = tabBarController(forPage: page)
    add(asChildViewController: vc)
    handleTabBarVisibility(shouldShowTabBar: true)
  }
}

extension TabBarContainerViewController: CoeurTabPageDelegate {
  func shouldChangeDisplay(toPage page: CoeurTabBarPage) {
    let vc = tabBarController(forPage: page)
    add(asChildViewController: vc)

    if case .tutorial = page {
      handleTabBarVisibility(shouldShowTabBar: false)
    }
  }

  func shouldChangeTabBarVisibility(shown: Bool) {
    handleTabBarVisibility(shouldShowTabBar: shown)
  }
}

extension TabBarContainerViewController:
  UIPageViewControllerDelegate,
  UIPageViewControllerDataSource
{

  fileprivate struct TutorialDataSource {
    // Data Source
    public static let tutorialPages = [
      CoeurTutorialPageData(tutorialPageImage: UIImage(named: "tutorial1Icon"),
                            tutorialPageTitle: "GET COMFORTABLE",
                            tutorialPageText: "• Relax and sit quietly\n• Uncross your legs and ankles\n• Support your back with a chair",
                            tutorialPageIndex: 0),
      CoeurTutorialPageData(tutorialPageImage: UIImage(named: "tutorial2Icon"),
                            tutorialPageTitle: "PLACE TOUR FINGER",
                            tutorialPageText: "• Press your index finger on the back camera of your phone",
                            tutorialPageIndex: 1),
      CoeurTutorialPageData(tutorialPageImage: UIImage(named: "tutorial3Icon"),
                            tutorialPageTitle: "POSITION YOUR PHONE FOR OPTIMAL ACCURACY",
                            tutorialPageText: "• Flip your hand so that the phone screen faces the sky\n• Elevate your hand to level with your heart\n• Place your arms on a table to reduce strain",
                            tutorialPageIndex: 2),
      CoeurTutorialPageData(tutorialPageImage: UIImage(named: "tutorial4Icon"),
                            tutorialPageTitle: "MEASURE YOUR BP",
                            tutorialPageText: "• Press the 'Start' button when you are ready\n• Wait for 1 minute until measurement is complete",
                            tutorialPageIndex: 3)
      ]
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let tutorialPage = viewController as? CoeurMeasureTutorialPageController else { return nil }

    var index = tutorialPage.pageIndex

    guard index > 0, index != NSNotFound else { return nil }

    index -= 1
    return pageController(atIndex: index)
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let tutorialPage = viewController as? CoeurMeasureTutorialPageController else { return nil }

    var index = tutorialPage.pageIndex

    guard index != NSNotFound else { return nil }

    index += 1
    return pageController(atIndex: index)
  }

  private func pageController(atIndex index: Int) -> CoeurMeasureTutorialPageController? {
    guard index < TutorialDataSource.tutorialPages.count,
          let tutorialPage = self.storyboard?.instantiateViewController(
            withIdentifier: "MeasureTutorialPage") as? CoeurMeasureTutorialPageController
    else {
      return nil
    }

    tutorialPage.configure(pageData: TutorialDataSource.tutorialPages[index])
    tutorialPage.view.frame = containerView.bounds

    return tutorialPage
  }

  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return TutorialDataSource.tutorialPages.count
  }

  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return 0
  }
}

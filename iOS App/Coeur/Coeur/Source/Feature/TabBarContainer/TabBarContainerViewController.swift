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

enum CoeurTutorialType {
  case measure
  case dashboard
}

class TabBarContainerViewController: UIViewController {

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var tabBarContainerView: CoeurTabBar!
  @IBOutlet weak var tabBarContainerViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var closeButton: UIButton!
  
  private var pageViewController: UIPageViewController?
  private var currentViewController: UIViewController?
  private var tutorialType: CoeurTutorialType = .dashboard // dashboard by default

  override func viewDidLoad() {
    // Set up for the MEasure Tutorial Screens
    self.pageViewController = storyboard?.instantiateViewController(withIdentifier: "MeasureTutorialPageViewController") as? CoeurMeasureTutorialPageViewController
    pageViewController?.delegate = self
    pageViewController?.dataSource = self
  }

  override func viewWillAppear(_ animated: Bool) {
    let tabBar = CoeurTabBar.instanceFromNib()
    tabBar.delegate = self
    tabBar.configure()
    tabBarContainerView.addSubview(tabBar)

    // By Default the X button is hidden
    closeButton.alpha = 0

    tabBar.leadingAnchor.constraint(equalTo: tabBarContainerView.leadingAnchor).isActive = true
    tabBar.trailingAnchor.constraint(equalTo: tabBarContainerView.trailingAnchor).isActive = true
    tabBar.topAnchor.constraint(equalTo: tabBarContainerView.topAnchor).isActive = true
    tabBar.bottomAnchor.constraint(equalTo: tabBarContainerView.bottomAnchor).isActive = true


    if !UserDefaults.standard.bool(forKey: CoeurUserDefaultKeys.kHasSeenDashboardTutorial) {
      UserDefaults.standard.set(true, forKey: CoeurUserDefaultKeys.kHasSeenDashboardTutorial)
      shouldChangeDisplay(toPage: .dashboardTutorial)
    } else {
      let vc = tabBarController(forPage: .dashboard)
      add(asChildViewController: vc)
    }
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
      let vc = DashboardViewController.dashboardViewController()
      let navController = UINavigationController(rootViewController: vc)
      return navController
    case .trends:
      let vc = TrendsViewController.trendsViewController()
      let navController = UINavigationController(rootViewController: vc)
      return navController
    case .measure:
      if !UserDefaults.standard.bool(forKey: CoeurUserDefaultKeys.kHasSeenMeasureTutorial) {
        UserDefaults.standard.set(true, forKey: CoeurUserDefaultKeys.kHasSeenMeasureTutorial)
        handleTabBarVisibility(shouldShowTabBar: false)
        return tabBarController(forPage: .measureTutorial)
      }

      let measureViewController = MeasureViewController.measureViewController()
      measureViewController.delegate = self
      return measureViewController

    case .measureTutorial:
      guard let tutorialPageViewController = pageViewController else {
        return tabBarController(forPage: .measure)
      }

      tutorialType = .measure
      guard let startingViewController = pageController(atIndex: 0) else { return tabBarController(forPage: .measure) }
      pageViewController?.setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)

      return tutorialPageViewController

    case .learn:
      if !UserDefaults.standard.bool(forKey: CoeurUserDefaultKeys.kHasSeenLearnLandingPage) {
        UserDefaults.standard.set(true, forKey: CoeurUserDefaultKeys.kHasSeenLearnLandingPage)
        let vc = LearnLandingViewController.learnLandingViewController()
        vc.delegate = self
        handleTabBarVisibility(shouldShowTabBar: false)
        self.closeButton.alpha = 0
        return vc
      }

      handleTabBarVisibility(shouldShowTabBar: true)
      let vc = LearnViewController.learnViewController()
      let navController = UINavigationController(rootViewController: vc)
      return navController

    case .community:
      return tabBarController(forPage: .measure)

    case .dashboardTutorial:
      guard let tutorialPageViewController = pageViewController else {
        return tabBarController(forPage: .dashboard)
      }

      tutorialType = .dashboard
      guard let startingViewController = pageController(atIndex: 0) else { return tabBarController(forPage: .dashboard) }
      pageViewController?.setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)

      return tutorialPageViewController
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
    switch tutorialType {
    case .dashboard:
      let vc = tabBarController(forPage: .dashboard)
      add(asChildViewController: vc)
    default:
      let vc = tabBarController(forPage: .measure)
      add(asChildViewController: vc)
    }

    handleTabBarVisibility(shouldShowTabBar: true)
  }
}

extension TabBarContainerViewController: CoeurTabBarDelegate {
  func tabBarButtonPressed(forPage page: CoeurTabBarPage) {
    let vc = tabBarController(forPage: page)
    add(asChildViewController: vc)
  }
}

extension TabBarContainerViewController: CoeurTabPageDelegate {
  func shouldChangeDisplay(toPage page: CoeurTabBarPage) {
    let vc = tabBarController(forPage: page)
    add(asChildViewController: vc)

    switch page {
    case .measureTutorial, .dashboardTutorial:
      handleTabBarVisibility(shouldShowTabBar: false)
    default: return
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

  fileprivate struct MeasureTutorialDataSource {
    // Data Source
    public static let tutorialPages = [
      CoeurTutorialPageData(tutorialPageImage: UIImage(named: "tutorial1Icon_measure.png"),
                            tutorialPageTitle: "GET COMFORTABLE",
                            tutorialPageText: "• Relax and sit quietly\n• Uncross your legs and ankles\n• Support your back with a chair",
                            tutorialPageIndex: 0,
                            backgroundImage: UIImage(named: "")),
      CoeurTutorialPageData(tutorialPageImage: UIImage(named: "tutorial1Icon_measure.png"),
                            tutorialPageTitle: "GET COMFORTABLE",
                            tutorialPageText: "• Relax and sit quietly\n• Uncross your legs and ankles\n• Support your back with a chair",
                            tutorialPageIndex: 1,
                            backgroundImage: UIImage(named: "")),
      CoeurTutorialPageData(tutorialPageImage: UIImage(named: "measureTutorialIcon2.png"),
                            tutorialPageTitle: "PLACE YOUR FINGER",
                            tutorialPageText: "• Press your index finger on the back camera of your phone",
                            tutorialPageIndex: 2,
                            backgroundImage: UIImage(named: "")),
      CoeurTutorialPageData(tutorialPageImage: UIImage(named: "Group_tutorial.png"),
                            tutorialPageTitle: "POSITION YOUR PHONE FOR OPTIMAL ACCURACY",
                            tutorialPageText: "• Flip your hand so that the phone screen faces the sky\n• Elevate your hand to level with your heart\n• Place your arms on a table to reduce strain",
                            tutorialPageIndex: 3,
                            backgroundImage: UIImage(named: "")),
      CoeurTutorialPageData(tutorialPageImage: UIImage(named: "measureTutorialIcon4"),
                            tutorialPageTitle: "MEASURE YOUR BP",
                            tutorialPageText: "• Press the 'Start' button when you are ready\n• Wait for 1 minute until measurement is complete",
                            tutorialPageIndex: 4,
                            backgroundImage: UIImage(named: ""))
      ]
  }

  fileprivate struct DashboardTutorialDataSource {
    // Data Source
    public static let tutorialPages = [
      CoeurTutorialPageData(tutorialPageImage: UIImage(),
                            tutorialPageTitle: "CHALLENGES",
                            tutorialPageText: "Every day you will get a set of challenges to complete. These are recommendations to help manage your blood pressure.",
                            tutorialPageIndex: 0,
                            backgroundImage: UIImage(named: "first time dashboard.png")),
      CoeurTutorialPageData(tutorialPageImage: UIImage(named: "challengesIcon_flat.png"),
                            tutorialPageTitle: "CHALLENGES",
                            tutorialPageText: "Every day you will get a set of challenges to complete. These are recommendations to help manage your blood pressure.",
                            tutorialPageIndex: 1,
                            backgroundImage: UIImage(named: "")),
      CoeurTutorialPageData(tutorialPageImage: UIImage(named: "streakIcon_flat.png"),
                            tutorialPageTitle: "STREAKS",
                            tutorialPageText: "Keep up your streak by logging into the app and measuring your blood pressure at least once a day",
                            tutorialPageIndex: 2,
                            backgroundImage: UIImage(named: "")),
      CoeurTutorialPageData(tutorialPageImage: UIImage(named: "rings_flat.png"),
                            tutorialPageTitle: "COMPLETE YOUR RINGS",
                            tutorialPageText: "Frequent blood pressure monitoring, completion of challenges, and keeping up with your streaks will add progress to your rings.\n\nComplete all challenges within the week to complete the outer ring.\n\nMaintain a 7-day streak to complete the inner ring",
                            tutorialPageIndex: 3,
                            backgroundImage: UIImage(named: "")),
    ]
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let tutorialPage = viewController as? CoeurTutorialPage else { return nil }

    var index = tutorialPage.pageIndex

    guard index > 0, index != NSNotFound else { return nil }

    index -= 1
    return pageController(atIndex: index)
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let tutorialPage = viewController as? CoeurTutorialPage else { return nil }

    var index = tutorialPage.pageIndex

    guard index != NSNotFound else { return nil }

    index += 1
    return pageController(atIndex: index)
  }

  private func pageController(atIndex index: Int) -> UIViewController? {
    guard let tutorialPage = self.storyboard?.instantiateViewController(withIdentifier: "MeasureTutorialPage") as? CoeurMeasureTutorialPageController else { return  nil }

    switch tutorialType {
    case .dashboard:
      guard index < DashboardTutorialDataSource.tutorialPages.count else { return nil }
      if index == 0 {
        let vc = DashboardLandingViewController.dashboardLandingViewController()
        vc.configure(pageData: DashboardTutorialDataSource.tutorialPages[index])
        vc.view.frame = containerView.bounds
        return vc
      }

      tutorialPage.configure(pageData: DashboardTutorialDataSource.tutorialPages[index])
    case .measure:
      guard index < MeasureTutorialDataSource.tutorialPages.count else { return nil }
      if index == 0 {
        let vc = MeasureLandingViewController.measureLandingViewController()
        vc.configure(pageData: MeasureTutorialDataSource.tutorialPages[index])
        vc.view.frame = containerView.bounds
        return vc
      }

      tutorialPage.configure(pageData: MeasureTutorialDataSource.tutorialPages[index])
    }

    tutorialPage.view.frame = containerView.bounds

    return tutorialPage
  }

//  func presentationCount(for pageViewController: UIPageViewController) -> Int {
//    switch tutorialType {
//    case .dashboard:
//      return DashboardTutorialDataSource.tutorialPages.count
//    case .measure:
//      return MeasureTutorialDataSource.tutorialPages.count
//    }
//  }
//
//  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//    return 0
//  }
}

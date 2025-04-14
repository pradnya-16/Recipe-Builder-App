Recipe Finder – iOS App 

Recipe Finder is a native iOS application built with Swift and UIKit. It allows users to select ingredients, find matching recipes, save favorites, and add their own custom recipes. The app uses Core Data for local persistent storage and integrates multi-touch gestures to enhance user interaction. It was developed as a final project for CSC-371/471 at DePaul University. 

🔍 Key Features 

- Ingredient selection from a dynamic list 
- Add/delete custom ingredients 
- Find matching recipes using Core Data filters 
- View detailed recipe pages with cooking timer 
- Add custom recipes manually 
- Favorites system with swipe gestures 
- All recipes screen with search capability 
- Tab bar navigation between major sections 
- Persistent data management using Core Data 

🛠️ Technologies Used 

- Swift 
- UIKit 
- Core Data 
- Tab Bar Controller 
- Auto Layout & Storyboard 
- Gesture Recognition 
- Xcode 

📱 How It Works 

Users begin by selecting ingredients they have on hand. The app filters and displays recipes that exactly match those ingredients. They can also add custom recipes, view recipe details with a timer, and mark recipes as favorites using swipe gestures. 

⚠️ Challenges Faced & Solutions 

- Favorites not updating in real-time → Solved with viewWillAppear 
- Duplicate ingredient entries in Core Data → Solved with pre-save checks 
- Incorrect recipe matches → Solved with allSatisfy logic to ensure complete ingredient matches 

🚀 Future Enhancements 

- Ingredient image recognition 
- Dietary filtering (vegan, gluten-free, etc.) 
- Cooking timer alerts and multitasking 
- User profiles and iCloud sync 

💬 Developer Experience 

This project sparked a deep interest in iOS development. From knowing nothing about Swift to building a full-fledged app, the learning curve was steep but rewarding. iOS felt more intuitive and powerful, especially using Storyboard, drag-and-drop tools, and Swift's expressive syntax. 

✅ Conclusion 

The Recipe Finder app demonstrates a solid understanding of iOS fundamentals, including Core Data, gesture handling, and interface navigation. Despite challenges, the app successfully meets its goals of delivering an intuitive and helpful recipe experience to users. 

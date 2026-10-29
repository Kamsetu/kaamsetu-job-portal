# KaamSetu — Full Job Portal Starter

तुझ्या सध्याच्या वेबसाइटचा `index.html` या पॅकेजमध्ये आहे. हा starter खालील गोष्टींची पायाभरणी देतो:

- Candidate account/profile UI
- Employer job-posting UI
- Job search आणि filters
- Apply flow UI
- Admin demo UI
- Database schema for profiles, jobs and applications
- PWA-ready manifest/service worker (installable web-app setup)
- Premium job posting साठी सुरक्षित payment integration ची तयारी

## महत्त्वाचं
फक्त GitHub Pages वर HTML टाकल्याने खरे login, shared database, resume upload, cross-user applications किंवा payment सुरू होत नाहीत. GitHub Pages static hosting आहे. हे live करण्यासाठी Supabase project आणि payment साठी backend/Edge Function आवश्यक आहेत. या starter मध्ये payment secrets नाहीत आणि कोणतेही खरे पैसे घेतले जात नाहीत.

## 1. GitHub वर वेबसाइट publish कर
1. `index.html` तुझ्या `kaamsetu-job-portal` repository च्या root मध्ये ठेवा.
2. Settings → Pages → Branch `main` → Folder `/(root)` → Save.

## 2. Database आणि Login साठी Supabase
1. Supabase मध्ये नवीन project तयार कर.
2. SQL Editor उघडून `schema.sql` मधील SQL run कर.
3. Authentication → Providers मध्ये Email sign-in सुरू कर.
4. Storage मध्ये `resumes` नावाचा private bucket तयार कर. PDF/DOC/DOCX फाइल्ससाठी आकार मर्यादा ठेव आणि user-folder आधारित policies वापर.
5. Supabase URL आणि anon/publishable key वापरून frontend जोडायचा. `service_role` key कधीही HTML/JavaScript किंवा GitHub मध्ये ठेवू नको.
6. RLS policies तपासूनच production मध्ये जा. Admin role फक्त trusted server-side पद्धतीने assign कर.

## 3. Resume upload
Resume private storage bucket मध्ये ठेवा. Employer ला फक्त त्याच्या job साठी apply केलेल्या candidate चा resume पाहण्याची signed URL द्या. Resume सार्वजनिक bucket मध्ये ठेवू नका.

## 4. Premium job posting / payment
Razorpay किंवा दुसरा payment provider वापरता येईल. पण order creation आणि payment signature verification server-side Edge Function वरच करा. Secret key frontend मध्ये कधीही ठेवू नका. Payment success verify झाल्यावरच job ला premium flag द्या.

## 5. Android app
सुरुवातीला PWA बनवणे सोपे आहे: manifest + service worker जोडून Chrome → menu → Add to Home screen वापरता येते. Play Store APK/AAB हवा असल्यास नंतर Android wrapper/Capacitor build आणि Play Console publishing करावे लागेल.

## Before launch checklist
- Real email/phone verification
- Password reset
- Resume storage privacy and size limits
- Admin server-side authorization
- Job moderation, report job, scam prevention
- Privacy policy, terms, contact/support page
- Payment webhook/signature verification and refund policy
- Backup, rate limits, spam protection, accessibility testing
- Demo/sample listings हटवून verified jobs वापरणे

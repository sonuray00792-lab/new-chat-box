/build
//val org.gradle.accessors.dm.LibrariesForLibs.picasso: kotlin.Any

plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.viber"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.viber"
        minSdk = 24
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = "11"
    }
}

dependencies {
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    implementation(libs.androidx.activity)
    implementation(libs.androidx.constraintlayout)
    implementation(libs.firebase.auth)
    implementation(libs.firebase.database)
    implementation(libs.androidx.recyclerview)
    implementation("com.google.firebase:firebase-storage")


    implementation(libs.material.v1110)
    implementation(libs.androidx.ui)


    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)

    // Firebase
    implementation(platform(libs.firebase.bom))
    implementation(libs.google.firebase.analytics)


    implementation("com.github.bumptech.glide:glide:5.0.5")

    implementation("androidx.core:core-splashscreen:1.0.1")


    //add module
    implementation(project(":statuslibrary"))
}
{
  "project_info": {
    "project_number": "737454890787",
    "project_id": "viber-6fb63",
    "storage_bucket": "viber-6fb63.firebasestorage.app"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:737454890787:android:085ba4dfbc9654a96bf696",
        "android_client_info": {
          "package_name": "com.example.viber"
        }
      },
      "oauth_client": [],
      "api_key": [
        {
          "current_key": "AIzaSyBoCZQYVFzTiMVmrCES07GMjNJem75qF2w"
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": []
        }
      }
    }
  ],
  "configuration_version": "1"
}
# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
package com.example.viber

import androidx.test.platform.app.InstrumentationRegistry
import androidx.test.ext.junit.runners.AndroidJUnit4

import org.junit.Test
import org.junit.runner.RunWith

import org.junit.Assert.*

/**
 * Instrumented test, which will execute on an Android device.
 *
 * See [testing documentation](http://d.android.com/tools/testing).
 */
@RunWith(AndroidJUnit4::class)
class ExampleInstrumentedTest {
    @Test
    fun useAppContext() {
        // Context of the app under test.
        val appContext = InstrumentationRegistry.getInstrumentation().targetContext
        assertEquals("com.example.viber", appContext.packageName)
    }
}
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <uses-feature
        android:name="android.hardware.telephony"
        android:required="false" />

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.CALL_PHONE" />

    <application
        android:allowBackup="true"
        android:dataExtractionRules="@xml/data_extraction_rules"
        android:fullBackupContent="@xml/backup_rules"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Viber">


        <activity
            android:name=".splash_screen"
            android:exported="true"
            android:theme="@style/Theme.Viber.Launcher">

        <intent-filter>
            <action android:name="android.intent.action.MAIN" />

            <category android:name="android.intent.category.LAUNCHER" />
        </intent-filter>

        </activity>


        <activity
            android:name=".Chat_Activity"
            android:fitsSystemWindows="true"
            android:windowSoftInputMode="adjustNothing|stateAlwaysHidden" />
        <activity
            android:name=".Signup"
            android:exported="false" />
        <activity
            android:name=".Login"
            android:exported="true">
        </activity>
        <activity
            android:name=".MainActivity"
            android:exported="false" />
    </application>

</manifest>
package com.example.viber

import android.content.Intent
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Bundle
import android.text.Layout
import android.util.Base64
import android.util.Log
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.google.android.material.imageview.ShapeableImageView
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener

class Chat_Activity : AppCompatActivity() {

    private lateinit var chatrecyclerview: RecyclerView
    private lateinit var messagebox: EditText
    private lateinit var sentbtn: ImageView
    private lateinit var messageadapter: Message_Adapter
    private lateinit var messagelist: ArrayList<Message>

    private lateinit var mdref: DatabaseReference

    val senderroom: String? = null
    val receiverroom: String? = null
    lateinit var receiveruidcall: String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_chat)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
        enableEdgeToEdge()
        window.statusBarColor = getColor(R.color.spirit)

        chatrecyclerview = findViewById<RecyclerView>(R.id.chatrecyclerview)
        messagebox = findViewById<EditText>(R.id.messagebox)
        sentbtn = findViewById<ImageView>(R.id.sendbtn)
        val chattoolbarr = findViewById<androidx.appcompat.widget.Toolbar>(R.id.chattoolbar)
        val toolbarTitle = chattoolbarr.findViewById<TextView>(R.id.viberTitle)

        val rootlayout = findViewById<View>(R.id.parentlayout)
        val chatlayout = findViewById<View>(R.id.linearlayout)


        val prefs = getSharedPreferences("settings", MODE_PRIVATE)
        val theme = prefs.getString("theme", "light")

        messagelist = ArrayList()
        messageadapter = Message_Adapter(this, messagelist, theme ?: "light")


        chatrecyclerview.layoutManager = LinearLayoutManager(this)
        chatrecyclerview.adapter = messageadapter

        chatrecyclerview.scrollToPosition(messageadapter.itemCount - 1)

        setSupportActionBar(chattoolbarr)
        supportActionBar?.title = ""

        val name = intent.getStringExtra("name")
        val receiveruid = intent.getStringExtra("uid")
        if (receiveruid.isNullOrEmpty()) {
            finish()
            return
        }


        val senderuid = FirebaseAuth.getInstance().currentUser?.uid
        mdref = FirebaseDatabase.getInstance().getReference()

        val backbtn = findViewById<ImageView>(R.id.back)
        backbtn.setOnClickListener {
            finish()
        }


        //profile set from firebase

        val profileimg = chattoolbarr.findViewById<ShapeableImageView>(R.id.chatpic)

        FirebaseDatabase.getInstance().getReference("user")
            .child(receiveruid)
            .addListenerForSingleValueEvent(object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {

                    if (!snapshot.exists()) {
                        profileimg.setImageResource(R.drawable.manprofile)
                        return
                    }

                    //Log.d("snapshot","${snapshot.value}")

                    val base64 = snapshot.child("profileimage").getValue(String::class.java)

                    if (!base64.isNullOrEmpty()){
                        val bytes = Base64.decode(base64, Base64.DEFAULT)
                        val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                        profileimg.setImageBitmap(bitmap)
                    }
                    else {
                        profileimg?.setImageResource(R.drawable.manprofile)
                    }
                }

                override fun onCancelled(error: DatabaseError) {}
            })


        //keyboard up comes
        val parentLayout = findViewById<View>(R.id.parentlayout)
        val chatLayout = findViewById<View>(R.id.linearlayout)

        val originalBottomPadding = chatLayout.paddingBottom


        ViewCompat.setOnApplyWindowInsetsListener(parentLayout) { _, insets ->

            val imeBottom = insets.getInsets(WindowInsetsCompat.Type.ime()).bottom
            val systemBottom = insets.getInsets(WindowInsetsCompat.Type.systemBars()).bottom

            // IMPORTANT: remove nav bar height from keyboard height
            val actualKeyboardHeight = (imeBottom - systemBottom).coerceAtLeast(0)

            chatLayout.setPadding(
                chatLayout.paddingLeft,
                chatLayout.paddingTop,
                chatLayout.paddingRight,
                originalBottomPadding + actualKeyboardHeight
            )

            // Smooth auto-scroll
            if (actualKeyboardHeight > 0 && messagelist.isNotEmpty()) {
                chatrecyclerview.post {
                    chatrecyclerview.scrollToPosition(messagelist.size - 1)
                }
            }

            insets   // ❌ DO NOT use WindowInsetsCompat.CONSUMED
        }


        receiveruidcall = intent.getStringExtra("uid")!!


        if (theme == "dark") {
            chattoolbarr.setTitleTextColor(Color.WHITE)
            chattoolbarr.setSubtitleTextColor(Color.WHITE)
            chattoolbarr.popupTheme = R.style.ToolbarDark
            chattoolbarr.setBackgroundColor(Color.parseColor("#0C0C0C"))
            backbtn.setColorFilter(Color.WHITE)
        } else {
            chattoolbarr.setTitleTextColor(Color.BLACK)
            chattoolbarr.setSubtitleTextColor(Color.BLACK)
            chattoolbarr.popupTheme = R.style.ToolbarLight
            chattoolbarr.setBackgroundColor(Color.parseColor("#EDECD9"))
        }

        val mychatll = findViewById<ConstraintLayout>(R.id.linearlayout)
        if (theme == "dark") {
            window.statusBarColor = Color.parseColor("#0C0C0C")
            chatrecyclerview.setBackgroundColor(Color.parseColor("#121212"))
            mychatll.setBackgroundColor(Color.parseColor("#121212"))
        } else {
            window.statusBarColor = Color.parseColor("#EDECD9")
            //chatrecyclerview.setBackgroundResource(R.drawable.viber_bg2)
            window.navigationBarColor = Color.parseColor("#FFFFFFFF")
        }

        toolbarTitle.setTextColor(
            if (theme == "dark") {
                Color.WHITE
            } else {
                Color.BLACK
            }
        )


        toolbarTitle.text = name

        val senderroom = receiveruid + senderuid
        val receiverroom = senderuid + receiveruid

        mdref.child("chats").child(senderroom).child("messages")
            .addValueEventListener(object : ValueEventListener {

                override fun onDataChange(snapshot: DataSnapshot) {

                    messagelist.clear()

                    for (postsnapshot in snapshot.children) {

                        val messageText = postsnapshot.child("message").getValue(String::class.java)
                        val senderId = postsnapshot.child("senderId").getValue(String::class.java)
                        val timestamp =
                            postsnapshot.child("timestamp").getValue(Long::class.java) ?: 0L

                        // 🔥 SAFE seen conversion (String + Boolean dono handle)
                        val seenValue = postsnapshot.child("seen").value
                        val seen = when (seenValue) {
                            is Boolean -> seenValue
                            is String -> seenValue.toBoolean()
                            else -> false
                        }

                        val message = Message(
                            message = messageText ?: "",
                            senderId = senderId,
                            seen = seen,
                            timestamp = timestamp
                        )

                        messagelist.add(message)

                        // mark seen if receiver
                        if (senderId != senderuid && !seen) {
                            postsnapshot.ref.child("seen").setValue(true) // ✅ BOOLEAN
                        }
                    }

                    messageadapter.notifyDataSetChanged()

                    chatrecyclerview.scrollToPosition(messagelist.size - 1)

                }

                override fun onCancelled(error: DatabaseError) {
                    TODO("Not yet implemented")
                }

            })

        sentbtn.setOnClickListener {

            val message = messagebox.text.toString().trim()
            val messageobject = Message(
                message = message,
                senderId = senderuid,
                seen = false,
                timestamp = System.currentTimeMillis()
            )

            if (message.isEmpty()) {
                return@setOnClickListener
            }

            mdref.child("chats").child(senderroom).child("messages").push()
                .setValue(messageobject).addOnSuccessListener {
                    mdref.child("chats").child(receiverroom).child("messages").push()
                        .setValue(messageobject)
                }
            messagebox.setText("")

            chatrecyclerview.scrollToPosition(messagelist.size - 1)

        }

    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.chat_menu, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {

        return when (item.itemId) {
            R.id.call -> {

                val dbref = FirebaseDatabase.getInstance().getReference("user")

                dbref.child(receiveruidcall!!)
                    .addListenerForSingleValueEvent(object : ValueEventListener {
                        override fun onDataChange(snapshot: DataSnapshot) {
                            val phone = snapshot.child("phonenum").getValue(String::class.java)

                            if (!phone.isNullOrEmpty()) {
                                makephonecall(phone)
                            } else {
                                Toast.makeText(
                                    this@Chat_Activity,
                                    "Phone number not found",
                                    Toast.LENGTH_SHORT
                                ).show()
                            }
                        }

                        override fun onCancelled(error: DatabaseError) {}
                    })

                true
            }

            else -> super.onOptionsItemSelected(item)

        }
    }

    override fun onPrepareOptionsMenu(menu: Menu?): Boolean {

        val prefs = getSharedPreferences("settings", MODE_PRIVATE)
        val theme = prefs.getString("theme", "light")

        menu?.let {
            for (i in 0 until it.size()) {
                val item = it.getItem(i)
                item.icon?.setTint(
                    if (theme == "dark") Color.WHITE else Color.BLACK
                )
            }
        }
        return super.onPrepareOptionsMenu(menu)
    }


    private fun makephonecall(phone: String) {
        val intent = Intent(Intent.ACTION_DIAL)
        intent.data = android.net.Uri.parse("tel:$phone")
        startActivity(intent)
    }

}
package com.example.viber

import android.content.Intent
import android.graphics.Color
import android.health.connect.datatypes.units.Length
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import com.google.firebase.auth.FirebaseAuth

class Login : AppCompatActivity() {

    private lateinit var etemail: EditText
    private lateinit var etpassword: EditText
    private lateinit var signinbtn: Button
    private lateinit var signupbtn: TextView
    private lateinit var mauth: FirebaseAuth


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_login)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        supportActionBar?.hide()

        mauth= FirebaseAuth.getInstance()

        // ✅ AUTO LOGIN CHECK
        if (mauth.currentUser != null) {
            startActivity(Intent(this, MainActivity::class.java))
            finish()
            return
        }

        window.statusBarColor = Color.parseColor("#0099FF")

        signupbtn= findViewById<TextView>(R.id.signupbtn)
        signinbtn= findViewById<Button>(R.id.signinbtn)
        etemail= findViewById<EditText>(R.id.etemail)
        etpassword= findViewById<EditText>(R.id.etpassword)

        signupbtn.setOnClickListener {
            val intent = Intent(this, Signup::class.java)
            startActivity(intent)
            finish()
        }

        signinbtn.setOnClickListener {
            val email= etemail.text.toString()
            val password= etpassword.text.toString()

            if (email.isEmpty()) {
                etemail.error = "Enter email"
                etemail.requestFocus()
                return@setOnClickListener
            }

            // Password empty check
            if (password.isEmpty()) {
                etpassword.error = "Enter password"
                etpassword.requestFocus()
                return@setOnClickListener
            }


            signin(email,password)
        }

    }

    private fun signin(email: String, password: String){
        mauth.signInWithEmailAndPassword(email, password)
            .addOnCompleteListener(this) { task ->
                if (task.isSuccessful) {
                    val intent = Intent(this, MainActivity::class.java)
                    intent.putExtra("SHOW_GREETING",true) // Flag
                    startActivity(intent)
                    finish()

                } else {
                    Toast.makeText(this,"User doesn't exist!", Toast.LENGTH_SHORT).show()
                }
            }
    }

}
package com.example.viber

import android.R.color.white
import android.app.Dialog
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Color
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import android.view.Menu
import android.view.MenuItem
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.app.AppCompatDelegate
import androidx.appcompat.widget.SearchView
import androidx.appcompat.widget.Toolbar
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener

import android.util.Base64
import java.io.ByteArrayOutputStream
import android.graphics.BitmapFactory
import android.view.animation.AnimationUtils
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.widget.AppCompatButton
import com.example.statuslibrary.statusActivity
import com.example.viber.utils.GreetingDialog


class MainActivity : AppCompatActivity() {


    lateinit var userRecyclerView: RecyclerView
    lateinit var adapter: User_adapter
    lateinit var userList: ArrayList<User>

    lateinit var fulluserlist: ArrayList<User>

    lateinit var mauth: FirebaseAuth

    lateinit var dbref: DatabaseReference

    private var dialog: Dialog? = null
    private var dialogprofilename: TextView? = null
    private var dialogprofileimage: ImageView? = null
    lateinit var savebutton: Button

    private var fileuri: Uri? = null
    private var selectedBitmap: Bitmap? = null


    override fun onCreate(savedInstanceState: Bundle?) {


        val prefs = getSharedPreferences("settings", MODE_PRIVATE)
        when (prefs.getString("theme", "light")) {  // default light
            "light" -> AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
            "dark" -> AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)
        }

        super.onCreate(savedInstanceState)

        if (FirebaseAuth.getInstance().currentUser == null) {
            val intent = Intent(this, Login::class.java)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            startActivity(intent)
            finish()
        }

        enableEdgeToEdge()
        setContentView(R.layout.activity_main)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        val showgretting = intent.getBooleanExtra("SHOW_GREETING",false)

        if (showgretting){
            showGreetingOnce()
        }

        window.statusBarColor = getColor(R.color.spirit)

        mauth = FirebaseAuth.getInstance()

        val pref = getSharedPreferences("settings", MODE_PRIVATE)
        val themes = pref.getString("theme", "light")


        userList = ArrayList()
        fulluserlist = ArrayList()
        adapter = User_adapter(this, userList,themes ?: "light")

        dbref = FirebaseDatabase.getInstance().getReference()

        userRecyclerView = findViewById<RecyclerView>(R.id.userrecyclerview)
        userRecyclerView.layoutManager = LinearLayoutManager(this)

        userRecyclerView.adapter = adapter


        val toolbar = findViewById<Toolbar>(R.id.maintoolbar)
        val searchview = findViewById<SearchView>(R.id.search)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayShowTitleEnabled(false)


        val theme = prefs.getString("theme", "light")

        if (theme == "dark") {
            toolbar.setTitleTextColor(Color.WHITE)
            toolbar.setSubtitleTextColor(Color.WHITE)
            toolbar.popupTheme = R.style.ToolbarDark
            toolbar.setBackgroundColor(Color.parseColor("#121212"))
        } else {
            toolbar.setTitleTextColor(Color.BLACK)
            toolbar.setSubtitleTextColor(Color.BLACK)
            toolbar.popupTheme = R.style.ToolbarLight
        }

        if (theme == "dark") {
            window.statusBarColor = Color.parseColor("#121212")
        }


        //statud btn


        val statusclick = findViewById<AppCompatButton>(R.id.btnStatus)

        statusclick.setOnClickListener {
            val intent = Intent(this, statusActivity::class.java)
            startActivity(intent)
        }



        dbref.child("user").addValueEventListener(object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {

                userList.clear()
                fulluserlist.clear()
                for (postsnapshot in snapshot.children) {
                    val currentuser = postsnapshot.getValue(User::class.java)

                    val myUid = mauth.currentUser?.uid

                    if (myUid != null && currentuser != null && myUid != currentuser.uid) {
                        userList.add(currentuser)
                        fulluserlist.add(currentuser)
                    }

                }

                adapter.notifyDataSetChanged()
            }

            override fun onCancelled(error: DatabaseError) {
                TODO("Not yet implemented")
            }

        })

        searchview.setOnQueryTextListener(object : SearchView.OnQueryTextListener {
            override fun onQueryTextSubmit(query: String?): Boolean {
                return false
            }

            override fun onQueryTextChange(newText: String?): Boolean {
                filterUsers(newText)
                return true
            }

        })


    }


    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.menu, menu)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {

        //setContentView(R.layout.dialog_layout)

        val pref = getSharedPreferences("settings", MODE_PRIVATE)
        val editor = pref.edit()

        if (item.itemId == R.id.menu) {

            val dialogView = layoutInflater.inflate(R.layout.dialog_layout, null)
            val dialog = AlertDialog.Builder(this)
                .setView(dialogView)
                .setCancelable(false)
                .create()

            dialog.window?.setBackgroundDrawableResource(android.R.color.transparent)

            dialogView.findViewById<TextView>(R.id.btnCancel).setOnClickListener {
                dialog.dismiss()
            }

            dialogView.findViewById<TextView>(R.id.btnLogout).setOnClickListener {
                mauth.signOut()

                val intent = Intent(this@MainActivity, Login::class.java)
                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
                finish()
            }

            dialog.show()
        }


        if (item.itemId == R.id.light) {
            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
            editor.putString("theme", "light")
            editor.apply()
        }

        if (item.itemId == R.id.dark) {
            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)
            editor.putString("theme", "dark")
            editor.apply()

        }

        if (item.itemId == R.id.profilepic) {

            dialog = Dialog(this)
            dialog?.setContentView(R.layout.custom_card)   // ✅ FIRST

            dialogprofilename = dialog?.findViewById<TextView>(R.id.profilename)
            dialogprofileimage = dialog?.findViewById<ImageView>(R.id.userrprofile)
            savebutton = dialog!!.findViewById<Button>(R.id.btnsave)

            dialog?.setCancelable(true)
            dialog?.window?.setBackgroundDrawableResource(android.R.color.transparent)


            val uid = mauth.currentUser?.uid


            //name show

                dbref.child("user").child(uid!!)
                    .addListenerForSingleValueEvent(object : ValueEventListener {
                        override fun onDataChange(snapshot: DataSnapshot) {
                            val name = snapshot.child("name").getValue(String::class.java)
                            dialogprofilename?.text = name ?: "User"
                        }
                        override fun onCancelled(error: DatabaseError) {}
                    })

            //profile show
            dbref.child("user").child(uid!!).child("profileimage")
                .addListenerForSingleValueEvent(object : ValueEventListener{
                    override fun onDataChange(snapshot: DataSnapshot) {
                        val base64 = snapshot.getValue(String::class.java)
                        if (!base64.isNullOrEmpty()) {
                            val bytes = Base64.decode(base64, Base64.DEFAULT)
                            val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                            dialogprofileimage?.setImageBitmap(bitmap)
                        }
                    }

                    override fun onCancelled(error: DatabaseError) {}

                })

            dialogprofileimage?.setOnClickListener {
                val intent = Intent()
                intent.type = "image/*"
                intent.action = Intent.ACTION_GET_CONTENT

                startActivityForResult(
                    Intent.createChooser(intent, "Choose image to upload"), 0
                )

            }


            savebutton.setOnClickListener {
                if (selectedBitmap != null && uid != null) {
                    uploadimagetorealtimeDB(uid,selectedBitmap!!)
                } else {
                    Toast.makeText(this, "Please select Image to upload", Toast.LENGTH_SHORT).show()
                }
            }


            dialog?.show()
        }

        return true
    }

    private fun uploadimagetorealtimeDB(uid: String,bitmap: Bitmap){
        val baos = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.JPEG, 40, baos)
        val imageBytes = baos.toByteArray()

        // ByteArray → Base64 String
        val imageBase64 = Base64.encodeToString(imageBytes, Base64.DEFAULT)

        dbref.child("user").child(uid)
            .child("profileimage").setValue(imageBase64)

            .addOnSuccessListener {
                Toast.makeText(this, "Profile Image Updated", Toast.LENGTH_SHORT).show()
                dialog?.dismiss()
            }
            .addOnFailureListener {
                Toast.makeText(this, "Upload Failed", Toast.LENGTH_SHORT).show()
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == 0 && resultCode == RESULT_OK && data != null && data.data != null) {

            fileuri = data.data
            try {
                val bitmap: Bitmap = MediaStore.Images.Media.getBitmap(contentResolver, fileuri)
                dialogprofileimage?.setImageBitmap(bitmap)

                selectedBitmap = bitmap

            } catch (e: Exception) {
                Log.e("Exception", "Error" + e)
            }
        }
    }

    private fun filterUsers(query: String?) {
        val filteredList = ArrayList<User>()
        if (!query.isNullOrEmpty()) {
            for (user in fulluserlist) {
                if (user.name?.lowercase()?.contains(query.lowercase()) == true) {
                    filteredList.add(user)
                }
            }
        } else {
            filteredList.addAll(fulluserlist)
        }

        adapter.filterList(filteredList)
    }


    //dialog making function

    private fun showGreetingOnce() {
        val uid = FirebaseAuth.getInstance().currentUser?.uid ?: return

        FirebaseDatabase.getInstance().getReference("user")
            .child(uid)
            .get()
            .addOnSuccessListener {
                val name = it.child("name").value.toString()
                Log.d("checkname","${name}")
                GreetingDialog.show(this, name)
            }
    }





}

package com.example.viber

class Message {

    var message : String? = null
    var senderId : String? = null
    var seen : Boolean = true
    var timestamp : Long = System.currentTimeMillis()


    constructor(){}

    constructor(message: String, senderId: String?,seen: Boolean,timestamp: Long){
        this.message = message
        this.senderId = senderId
        this.seen = seen
        this.timestamp = timestamp
    }
}
package com.example.viber

import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.google.firebase.auth.FirebaseAuth

class Message_Adapter(val context: Context,val  messagelist: ArrayList<Message>,val theme: String):
    RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    val ITEM_RECEIVE = 1
    val ITEM_SENT = 2

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {

        if (viewType == 1){
            val view: View = LayoutInflater.from(context).inflate(R.layout.receive,parent,false)
            return receiveviewholder(view)
        }
        else{
            val view: View = LayoutInflater.from(context).inflate(R.layout.sent,parent,false)
            return sentviewholder(view)
        }

    }

    override fun getItemViewType(position: Int): Int {

        val currentmessage = messagelist[position]
        if (FirebaseAuth.getInstance().currentUser?.uid.equals(currentmessage.senderId)){
            return ITEM_SENT
        }
        else{
            return ITEM_RECEIVE
        }
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {

        val current = messagelist[position]
        val container1 = holder.itemView.findViewById<LinearLayout>(R.id.sent_container)
        val container2 = holder.itemView.findViewById<LinearLayout>(R.id.receive_container)


        if (holder::class.java == sentviewholder::class.java){
            val viewholder = holder as sentviewholder

            holder.sentmessage.text = current.message

            if (theme == "dark"){
                container1.setBackgroundResource(R.drawable.bg_sent_message)
                holder.sentmessage.setTextColor(Color.WHITE)
            }else{
                container1.setBackgroundResource(R.drawable.sent_light)
                holder.sentmessage.setTextColor(Color.BLACK)
            }

        }
        else{
            val viewholder = holder as receiveviewholder

            holder.receivemessage.text = current.message

            if (theme == "dark") {
                container2.setBackgroundResource(R.drawable.bg_receive_message)
                holder.receivemessage.setTextColor(Color.WHITE)
            } else {
                container2.setBackgroundResource(R.drawable.receive_light)
                holder.receivemessage.setTextColor(Color.BLACK)
            }
        }

    }

    override fun getItemCount(): Int {
        return messagelist.size
    }

    class sentviewholder(itemview: View): RecyclerView.ViewHolder(itemview){
        val sentmessage = itemview.findViewById<TextView>(R.id.txt_sent_msg)
    }

    class receiveviewholder(itemview: View): RecyclerView.ViewHolder(itemview){
        val receivemessage = itemview.findViewById<TextView>(R.id.txt_receive_msg)
    }
}
package com.example.viber

import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.credentials.playservices.CredentialProviderMetadataHolder
import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase

class Signup : AppCompatActivity() {

    private lateinit var etname: EditText
    private lateinit var etemail: EditText
    private lateinit var etpassword: EditText
    private lateinit var etphone: EditText
    private lateinit var signupbtn: Button
    private lateinit var mauth: FirebaseAuth

    private lateinit var dbref: DatabaseReference

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_signup)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        supportActionBar?.hide()

        mauth= FirebaseAuth.getInstance()

        etname= findViewById<EditText>(R.id.etname)
        etemail= findViewById<EditText>(R.id.etemail)
        etpassword= findViewById<EditText>(R.id.etpassword)
        etphone = findViewById<EditText>(R.id.etphone)
        signupbtn= findViewById<Button>(R.id.signupbtn)

        window.statusBarColor= Color.parseColor("#0099FF")

        val txtsignin = findViewById<TextView>(R.id.loginText)

        txtsignin.setOnClickListener {
            val intent = Intent(this, Login::class.java)
            startActivity(intent)
            finish()
        }

        signupbtn.setOnClickListener {
            val name= etname.text.toString()
            val email= etemail.text.toString()
            val password= etpassword.text.toString()
            val phonenum = etphone.text.toString()

            when{
                name.isEmpty()->{
                    etname.error="name required"
                    etname.requestFocus()
                }
                email.isEmpty()->{
                    etname.error="email required"
                    etname.requestFocus()
                }
                password.isEmpty()->{
                    etpassword.error="password reuired"
                    etpassword.requestFocus()
                }
                password.length<6->{
                    etpassword.error="password must be atleast 6 character"
                }
                phonenum.isEmpty()->{
                    etphone.error="phone number is reuired"
                }
                phonenum.length != 10 -> {
                    etphone.error = "Enter valid 10 digit phone number"
                    etphone.requestFocus()
                }

                else -> {
                    signup(name, email, password, phonenum)
                }
            }
        }
    }

    private fun signup(name: String,email: String,password: String,phonenum: String){

        if (name.isEmpty() || email.isEmpty() || password.isEmpty() || phonenum.isEmpty()) {
            Toast.makeText(this, "All fields are required", Toast.LENGTH_SHORT).show()
            return
        }

        mauth.createUserWithEmailAndPassword(email, password)
            .addOnCompleteListener(this) { task ->
                if (task.isSuccessful) {

                    addUserToDatabase(name,email,mauth.currentUser?.uid!!,phonenum)

                    val intent = Intent(this, MainActivity::class.java)
                    intent.putExtra("SHOW_GREETING",true) // Flag
                    startActivity(intent)
                    finish()

                } else {
                    Toast.makeText(this,"Some Error Occured!", Toast.LENGTH_SHORT).show()
                }
            }

    }

    private fun addUserToDatabase(name: String,email: String,uid: String,phonenum: String){
        dbref = FirebaseDatabase.getInstance().getReference()
        dbref.child("user").child(uid).setValue(User(name,email,uid,phonenum))
    }

}
package com.example.viber

class User {
    var name: String? = null
    var email: String? = null
    var uid: String? = null
    var phonenum: String?= null
    var profileimage: String? = null
    // Default constructor required for Firebase
    constructor()

    // Full constructor with default null for profileImage
    constructor(name: String?, email: String?, uid: String?,phonenum: String?,profileimage: String?=null) {
        this.name = name
        this.email = email
        this.uid = uid
        this.phonenum = phonenum
        this.profileimage=profileimage
    }
}

package com.example.viber

import android.R.attr.theme
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.graphics.Color
import android.util.Base64
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale


class User_adapter(val context: Context, val userlist: ArrayList<User>,val theme : String):
    RecyclerView.Adapter<User_adapter.UserViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): User_adapter.UserViewHolder {
        val view: View = LayoutInflater.from(context).inflate(R.layout.user_layout,parent,false)
        return UserViewHolder(view)
    }

    override fun onBindViewHolder(holder: User_adapter.UserViewHolder, position: Int) {
        val current= userlist[position]

        holder.unreadCount.visibility = View.GONE
        holder.unreadCount.text = ""
        holder.lastMessage.text = ""
        holder.msgtime.text = ""


        holder.textname.text= current.name

        holder.clickuser.setOnClickListener {

            val intent = Intent(context, Chat_Activity::class.java)

            intent.putExtra("name",current.name)
            intent.putExtra("uid", current.uid)

            context.startActivity(intent)
        }

        //profile show per person

        if (!current.profileimage.isNullOrEmpty()){
            val bytes = Base64.decode(current.profileimage, Base64.DEFAULT)
            val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
            holder.profileimageview.setImageBitmap(bitmap)
        }else{
            holder.profileimageview.setImageResource(R.drawable.manprofile)
        }

        //current badge and last message

        val currentUserID = FirebaseAuth.getInstance().currentUser!!.uid
        val senderRoom = current.uid + currentUserID

        FirebaseDatabase.getInstance().getReference("chats")
            .child(senderRoom)
            .child("messages")
            .addValueEventListener(object : ValueEventListener{
                override fun onDataChange(snapshot: DataSnapshot) {
                    var unread = 0
                    var lastMsg = "No messages yet"
                    var lastTime = 0L

                    for (msgsnap in snapshot.children){
                        val messageSnapshot = msgsnap
                        val messageText = messageSnapshot.child("message").getValue(String::class.java) ?: ""
                        val senderId = messageSnapshot.child("senderId").getValue(String::class.java) ?: ""
                        val seenValue = messageSnapshot.child("seen").value
                        val seen = when (seenValue) {
                            is Boolean -> seenValue
                            is String -> seenValue.toBoolean()
                            else -> false
                        }
                        val timestamp = messageSnapshot.child("timestamp").getValue(Long::class.java) ?: 0L
                        val msg = Message(messageText, senderId, seen, timestamp)

                        if (!seen && msg.senderId != currentUserID){
                            unread++
                        }

                        if (msg.timestamp > lastTime){
                            lastTime = msg.timestamp
                            lastMsg = msg.message ?: ""
                        }
                    }


                    val index = userlist.indexOf(current)
                    if (index != 0 && index >= 0) {
                        userlist.removeAt(index)
                        userlist.add(0, current)
                        notifyItemMoved(index, 0)
                    }



                    // Set last message & time
                    holder.lastMessage.text = lastMsg
                    if (lastTime > 0L) {
                        val date = Date(lastTime)
                        val timeFormat = SimpleDateFormat("hh:mm a", Locale.getDefault())
                        holder.msgtime.visibility = View.VISIBLE
                        holder.msgtime.text = timeFormat.format(date)
                    } else {
                        // New user: no messages yet
                        holder.msgtime.visibility = View.VISIBLE
                        holder.msgtime.text = "Time"   // placeholder instead of blank
                    }

                    // unread badge
                    if (unread > 0){
                        holder.unreadCount.visibility = View.VISIBLE
                        holder.unreadCount.text = unread.toString()
                    } else {
                        holder.unreadCount.visibility = View.GONE
                    }
                }


                override fun onCancelled(error: DatabaseError) {}

            })

        //background color
        if (theme == "dark"){
            holder.textname.setTextColor(Color.WHITE)
        }



    }

    override fun getItemCount(): Int {
        return userlist.size
    }

    class UserViewHolder(itemView: View): RecyclerView.ViewHolder(itemView){
        val textname = itemView.findViewById<TextView>(R.id.txt_name)
        val profileimageview : ImageView = itemView.findViewById<ImageView>(R.id.profileid)
        val clickuser : LinearLayout = itemView.findViewById<LinearLayout>(R.id.llname)
        val unreadCount  = itemView.findViewById<TextView>(R.id.txt_unread_count)
        val lastMessage = itemView.findViewById<TextView>(R.id.txt_last_message)
        val msgtime = itemView.findViewById<TextView>(R.id.txt_time)

    }

    fun filterList(filteredList: ArrayList<User>) {
        userlist.clear()
        userlist.addAll(filteredList)
        notifyDataSetChanged()
    }


}
package com.example.viber.utils

import android.app.Dialog
import android.content.Context
import android.view.LayoutInflater
import android.view.animation.AnimationUtils
import android.widget.Button
import android.widget.TextView
import com.example.viber.R

object GreetingDialog {

    fun show(context: Context, userName: String) {
        val dialog = Dialog(context)
        val view = LayoutInflater.from(context)
            .inflate(R.layout.activity_greeting_dialog, null)

        dialog.setContentView(view)
        dialog.setCancelable(false)

        val txtUser = view.findViewById<TextView>(R.id.txtUsername)
        val btnContinue = view.findViewById<Button>(R.id.btnContinue)

        txtUser.text = "Hello, $userName 😊"

        val anim = AnimationUtils.loadAnimation(context, R.anim.dialog_scale)
        view.startAnimation(anim)

        btnContinue.setOnClickListener {
            dialog.dismiss()
        }

        dialog.show()
    }
}

package com.example.viber

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.FirebaseDatabase

class splash_screen : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        setTheme(R.style.Theme_Viber)
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_splash_screen)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }


        supportActionBar?.hide()

        Handler(Looper.getMainLooper()).postDelayed({
            val user = FirebaseAuth.getInstance().currentUser

            if (user != null) {
                startActivity(Intent(this, MainActivity::class.java))
            } else {
                startActivity(Intent(this, Login::class.java))
            }

            finish()
        }, 1500)


    }
}
<scale xmlns:android="http://schemas.android.com/apk/res/android"
    android:fromXScale="0.8"
    android:fromYScale="0.8"
    android:toXScale="1"
    android:toYScale="1"
    android:duration="300"
    android:pivotX="50%"
    android:pivotY="50%"/>

<scale xmlns:android="http://schemas.android.com/apk/res/android"
    android:fromXScale="1"
    android:toXScale="1.08"
    android:fromYScale="1"
    android:toYScale="1.08"
    android:pivotX="50%"
    android:pivotY="50%"
    android:duration="900"
    android:repeatCount="infinite"
    android:repeatMode="reverse"/>

<vector xmlns:android="http://schemas.android.com/apk/res/android" android:height="24dp" android:tint="#000000" android:viewportHeight="24" android:viewportWidth="24" android:width="24dp">
      
    <path android:fillColor="@android:color/white" android:pathData="M20.01,15.38c-1.23,0 -2.42,-0.2 -3.53,-0.56 -0.35,-0.12 -0.74,-0.03 -1.01,0.24l-1.57,1.97c-2.83,-1.35 -5.48,-3.9 -6.89,-6.83l1.95,-1.66c0.27,-0.28 0.35,-0.67 0.24,-1.02 -0.37,-1.11 -0.56,-2.3 -0.56,-3.53 0,-0.54 -0.45,-0.99 -0.99,-0.99H4.19C3.65,3 3,3.24 3,3.99 3,13.28 10.73,21 20.01,21c0.71,0 0.99,-0.63 0.99,-1.18v-3.45c0,-0.54 -0.45,-0.99 -0.99,-0.99z"/>
    
</vector>

<vector xmlns:android="http://schemas.android.com/apk/res/android" android:height="24dp" android:tint="#000000" android:viewportHeight="24" android:viewportWidth="24" android:width="24dp">
      
    <path android:fillColor="@android:color/white" android:pathData="M20,4L4,4c-1.1,0 -1.99,0.9 -1.99,2L2,18c0,1.1 0.9,2 2,2h16c1.1,0 2,-0.9 2,-2L22,6c0,-1.1 -0.9,-2 -2,-2zM20,8l-8,5 -8,-5L4,6l8,5 8,-5v2z"/>
    
</vector>

<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="#FFFFFF"/>
    <corners android:radius="20dp"/>
    <padding
        android:left="16dp"
        android:top="16dp"
        android:right="16dp"
        android:bottom="16dp"/>
</shape>

<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">

    <solid android:color="#242626" />

    <corners
        android:topLeftRadius="16dp"
        android:topRightRadius="16dp"
        android:bottomLeftRadius="0dp"
        android:bottomRightRadius="16dp" />
</shape>

<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">

    <solid android:color="#444956" />

    <corners
        android:topLeftRadius="16dp"
        android:topRightRadius="16dp"
        android:bottomLeftRadius="16dp"
        android:bottomRightRadius="0dp" />
</shape>

<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="#25D366"/>
    <corners android:radius="24dp"/>
</shape>

<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android">

    <stroke
        android:width="3dp"
        android:color="#6C716D" />

    <corners android:radius="20dp" />
    <padding
        android:bottom="7dp"
        android:left="7dp"
        android:right="7dp"
        android:top="7dp" />


</shape>
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@android:color/white"/>
    <corners android:radius="20dp"/>
</shape>

<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#3DDC84"
        android:pathData="M0,0h108v108h-108z" />
    <path
        android:fillColor="#00000000"
        android:pathData="M9,0L9,108"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M19,0L19,108"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M29,0L29,108"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M39,0L39,108"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M49,0L49,108"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M59,0L59,108"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M69,0L69,108"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M79,0L79,108"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M89,0L89,108"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M99,0L99,108"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M0,9L108,9"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M0,19L108,19"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M0,29L108,29"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M0,39L108,39"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M0,49L108,49"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M0,59L108,59"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M0,69L108,69"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M0,79L108,79"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M0,89L108,89"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M0,99L108,99"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M19,29L89,29"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M19,39L89,39"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M19,49L89,49"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M19,59L89,59"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M19,69L89,69"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M19,79L89,79"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M29,19L29,89"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M39,19L39,89"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M49,19L49,89"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M59,19L59,89"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M69,19L69,89"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
    <path
        android:fillColor="#00000000"
        android:pathData="M79,19L79,89"
        android:strokeWidth="0.8"
        android:strokeColor="#33FFFFFF" />
</vector>

<vector xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:aapt="http://schemas.android.com/aapt"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path android:pathData="M31,63.928c0,0 6.4,-11 12.1,-13.1c7.2,-2.6 26,-1.4 26,-1.4l38.1,38.1L107,108.928l-32,-1L31,63.928z">
        <aapt:attr name="android:fillColor">
            <gradient
                android:endX="85.84757"
                android:endY="92.4963"
                android:startX="42.9492"
                android:startY="49.59793"
                android:type="linear">
                <item
                    android:color="#44000000"
                    android:offset="0.0" />
                <item
                    android:color="#00000000"
                    android:offset="1.0" />
            </gradient>
        </aapt:attr>
    </path>
    <path
        android:fillColor="#FFFFFF"
        android:fillType="nonZero"
        android:pathData="M65.3,45.828l3.8,-6.6c0.2,-0.4 0.1,-0.9 -0.3,-1.1c-0.4,-0.2 -0.9,-0.1 -1.1,0.3l-3.9,6.7c-6.3,-2.8 -13.4,-2.8 -19.7,0l-3.9,-6.7c-0.2,-0.4 -0.7,-0.5 -1.1,-0.3C38.8,38.328 38.7,38.828 38.9,39.228l3.8,6.6C36.2,49.428 31.7,56.028 31,63.928h46C76.3,56.028 71.8,49.428 65.3,45.828zM43.4,57.328c-0.8,0 -1.5,-0.5 -1.8,-1.2c-0.3,-0.7 -0.1,-1.5 0.4,-2.1c0.5,-0.5 1.4,-0.7 2.1,-0.4c0.7,0.3 1.2,1 1.2,1.8C45.3,56.528 44.5,57.328 43.4,57.328L43.4,57.328zM64.6,57.328c-0.8,0 -1.5,-0.5 -1.8,-1.2s-0.1,-1.5 0.4,-2.1c0.5,-0.5 1.4,-0.7 2.1,-0.4c0.7,0.3 1.2,1 1.2,1.8C66.5,56.528 65.6,57.328 64.6,57.328L64.6,57.328z"
        android:strokeWidth="1"
        android:strokeColor="#00000000" />
</vector>
<vector xmlns:android="http://schemas.android.com/apk/res/android" android:height="24dp" android:tint="#000000" android:viewportHeight="24" android:viewportWidth="24" android:width="24dp">
      
    <path android:fillColor="@android:color/white" android:pathData="M18,8h-1L17,6c0,-2.76 -2.24,-5 -5,-5S7,3.24 7,6v2L6,8c-1.1,0 -2,0.9 -2,2v10c0,1.1 0.9,2 2,2h12c1.1,0 2,-0.9 2,-2L20,10c0,-1.1 -0.9,-2 -2,-2zM12,17c-1.1,0 -2,-0.9 -2,-2s0.9,-2 2,-2 2,0.9 2,2 -0.9,2 -2,2zM15.1,8L8.9,8L8.9,6c0,-1.71 1.39,-3.1 3.1,-3.1 1.71,0 3.1,1.39 3.1,3.1v2z"/>
    
</vector>

<vector xmlns:android="http://schemas.android.com/apk/res/android" android:height="24dp" android:tint="#000000" android:viewportHeight="24" android:viewportWidth="24" android:width="24dp">
      
    <path android:fillColor="@android:color/white" android:pathData="M12,12c2.21,0 4,-1.79 4,-4s-1.79,-4 -4,-4 -4,1.79 -4,4 1.79,4 4,4zM12,14c-2.67,0 -8,1.34 -8,4v2h16v-2c0,-2.66 -5.33,-4 -8,-4z"/>
    
</vector>

<vector xmlns:android="http://schemas.android.com/apk/res/android" android:height="24dp" android:tint="#000000" android:viewportHeight="960" android:viewportWidth="960" android:width="24dp">
      
    <path android:fillColor="@android:color/white" android:pathData="M234,684Q285,645 348,622.5Q411,600 480,600Q549,600 612,622.5Q675,645 726,684Q761,643 780.5,591Q800,539 800,480Q800,347 706.5,253.5Q613,160 480,160Q347,160 253.5,253.5Q160,347 160,480Q160,539 179.5,591Q199,643 234,684ZM480,520Q421,520 380.5,479.5Q340,439 340,380Q340,321 380.5,280.5Q421,240 480,240Q539,240 579.5,280.5Q620,321 620,380Q620,439 579.5,479.5Q539,520 480,520ZM480,880Q397,880 324,848.5Q251,817 197,763Q143,709 111.5,636Q80,563 80,480Q80,397 111.5,324Q143,251 197,197Q251,143 324,111.5Q397,80 480,80Q563,80 636,111.5Q709,143 763,197Q817,251 848.5,324Q880,397 880,480Q880,563 848.5,636Q817,709 763,763Q709,817 636,848.5Q563,880 480,880ZM480,800Q533,800 580,784.5Q627,769 666,740Q627,711 580,695.5Q533,680 480,680Q427,680 380,695.5Q333,711 294,740Q333,769 380,784.5Q427,800 480,800ZM480,440Q506,440 523,423Q540,406 540,380Q540,354 523,337Q506,320 480,320Q454,320 437,337Q420,354 420,380Q420,406 437,423Q454,440 480,440ZM480,380Q480,380 480,380Q480,380 480,380Q480,380 480,380Q480,380 480,380Q480,380 480,380Q480,380 480,380Q480,380 480,380Q480,380 480,380ZM480,740Q480,740 480,740Q480,740 480,740Q480,740 480,740Q480,740 480,740Q480,740 480,740Q480,740 480,740Q480,740 480,740Q480,740 480,740Z"/>
    
</vector>

<vector xmlns:android="http://schemas.android.com/apk/res/android" android:height="24dp" android:tint="#000000" android:viewportHeight="24" android:viewportWidth="24" android:width="24dp">
      
    <path android:fillColor="@android:color/white" android:pathData="M6.62,10.79c1.44,2.83 3.76,5.14 6.59,6.59l2.2,-2.2c0.27,-0.27 0.67,-0.36 1.02,-0.24 1.12,0.37 2.33,0.57 3.57,0.57 0.55,0 1,0.45 1,1V20c0,0.55 -0.45,1 -1,1 -9.39,0 -17,-7.61 -17,-17 0,-0.55 0.45,-1 1,-1h3.5c0.55,0 1,0.45 1,1 0,1.25 0.2,2.45 0.57,3.57 0.11,0.35 0.03,0.74 -0.25,1.02l-2.2,2.2z"/>
    
</vector>

<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="oval">
    <solid android:color="#25D366"/>
</shape>

<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">

    <solid android:color="@color/chat2" />

    <corners
        android:topLeftRadius="16dp"
        android:topRightRadius="16dp"
        android:bottomLeftRadius="0dp"
        android:bottomRightRadius="16dp" />
</shape>

<?xml version="1.0" encoding="utf-8"?>
<shape android:shape="rectangle" xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="#FFFFFF"/>
    <stroke android:color="#0099ff"
        android:width="1dp"/>
    <corners android:radius="100dp"/>
</shape>
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android">

    <corners android:radius="20dp"/>

    <stroke
        android:color="@color/spirit"
        android:width="2dp"/>
</shape>
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">

    <solid android:color="@color/chat1" />

    <corners
        android:topLeftRadius="16dp"
        android:topRightRadius="16dp"
        android:bottomLeftRadius="16dp"
        android:bottomRightRadius="0dp" />
</shape>

<layer-list xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Blue Background -->
    <item android:color="#0099FF"/>

    <!-- Center App Icon -->
    <item>
        <bitmap
            android:gravity="center"
            android:src="@drawable/viber_icon" />
    </item>

</layer-list>

<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">

    <solid android:color="#15A38C"/>

    <corners android:radius="22dp"/>

    <padding
        android:left="16dp"
        android:top="8dp"
        android:right="16dp"
        android:bottom="8dp"/>
</shape>

<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="oval">
    <solid android:color="#25D366" />
</shape>
Copyright 2016 The Dancing Script Project Authors (https://github.com/googlefonts/DancingScript), with Reserved Font Name 'Dancing Script'.

This Font Software is licensed under the SIL Open Font License, Version 1.1.
This license is copied below, and is also available with a FAQ at:
https://openfontlicense.org


-----------------------------------------------------------
SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007
-----------------------------------------------------------

PREAMBLE
The goals of the Open Font License (OFL) are to stimulate worldwide
development of collaborative font projects, to support the font creation
efforts of academic and linguistic communities, and to provide a free and
open framework in which fonts may be shared and improved in partnership
with others.

The OFL allows the licensed fonts to be used, studied, modified and
redistributed freely as long as they are not sold by themselves. The
fonts, including any derivative works, can be bundled, embedded, 
redistributed and/or sold with any software provided that any reserved
names are not used by derivative works. The fonts and derivatives,
however, cannot be released under any other type of license. The
requirement for fonts to remain under this license does not apply
to any document created using the fonts or their derivatives.

DEFINITIONS
"Font Software" refers to the set of files released by the Copyright
Holder(s) under this license and clearly marked as such. This may
include source files, build scripts and documentation.

"Reserved Font Name" refers to any names specified as such after the
copyright statement(s).

"Original Version" refers to the collection of Font Software components as
distributed by the Copyright Holder(s).

"Modified Version" refers to any derivative made by adding to, deleting,
or substituting -- in part or in whole -- any of the components of the
Original Version, by changing formats or by porting the Font Software to a
new environment.

"Author" refers to any designer, engineer, programmer, technical
writer or other person who contributed to the Font Software.

PERMISSION & CONDITIONS
Permission is hereby granted, free of charge, to any person obtaining
a copy of the Font Software, to use, study, copy, merge, embed, modify,
redistribute, and sell modified and unmodified copies of the Font
Software, subject to the following conditions:

1) Neither the Font Software nor any of its individual components,
in Original or Modified Versions, may be sold by itself.

2) Original or Modified Versions of the Font Software may be bundled,
redistributed and/or sold with any software, provided that each copy
contains the above copyright notice and this license. These can be
included either as stand-alone text files, human-readable headers or
in the appropriate machine-readable metadata fields within text or
binary files as long as those fields can be easily viewed by the user.

3) No Modified Version of the Font Software may use the Reserved Font
Name(s) unless explicit written permission is granted by the corresponding
Copyright Holder. This restriction only applies to the primary font name as
presented to the users.

4) The name(s) of the Copyright Holder(s) or the Author(s) of the Font
Software shall not be used to promote, endorse or advertise any
Modified Version, except to acknowledge the contribution(s) of the
Copyright Holder(s) and the Author(s) or with their explicit written
permission.

5) The Font Software, modified or unmodified, in part or in whole,
must be distributed entirely under this license, and must not be
distributed under any other license. The requirement for fonts to
remain under this license does not apply to any document created
using the Font Software.

TERMINATION
This license becomes null and void if any of the above conditions are
not met.

DISCLAIMER
THE FONT SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
OF COPYRIGHT, PATENT, TRADEMARK, OR OTHER RIGHT. IN NO EVENT SHALL THE
COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
INCLUDING ANY GENERAL, SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL
DAMAGES, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF THE USE OR INABILITY TO USE THE FONT SOFTWARE OR FROM
OTHER DEALINGS IN THE FONT SOFTWARE.

Dancing Script Variable Font
============================

This download contains Dancing Script as both a variable font and static fonts.

Dancing Script is a variable font with this axis:
  wght

This means all the styles are contained in a single file:
  DancingScript-VariableFont_wght.ttf

If your app fully supports variable fonts, you can now pick intermediate styles
that aren’t available as static fonts. Not all apps support variable fonts, and
in those cases you can use the static font files for Dancing Script:
  static/DancingScript-Regular.ttf
  static/DancingScript-Medium.ttf
  static/DancingScript-SemiBold.ttf
  static/DancingScript-Bold.ttf

Get started
-----------

1. Install the font files you want to use

2. Use your app's font picker to view the font family and all the
available styles

Learn more about variable fonts
-------------------------------

  https://developers.google.com/web/fundamentals/design-and-ux/typography/variable-fonts
  https://variablefonts.typenetwork.com
  https://medium.com/variable-fonts

In desktop apps

  https://theblog.adobe.com/can-variable-fonts-illustrator-cc
  https://helpx.adobe.com/nz/photoshop/using/fonts.html#variable_fonts

Online

  https://developers.google.com/fonts/docs/getting_started
  https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Fonts/Variable_Fonts_Guide
  https://developer.microsoft.com/en-us/microsoft-edge/testdrive/demos/variable-fonts

Installing fonts

  MacOS: https://support.apple.com/en-us/HT201749
  Linux: https://www.google.com/search?q=how+to+install+a+font+on+gnu%2Blinux
  Windows: https://support.microsoft.com/en-us/help/314960/how-to-install-or-remove-a-font-in-windows

Android Apps

  https://developers.google.com/fonts/docs/android
  https://developer.android.com/guide/topics/ui/look-and-feel/downloadable-fonts

License
-------
Please read the full license text (OFL.txt) to understand the permissions,
restrictions and requirements for usage, redistribution, and modification.

You can use them in your products & projects – print or digital,
commercial or otherwise.

This isn't legal advice, please consider consulting a lawyer and see the full
license for all details.

<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/main"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".Chat_Activity">

    <androidx.constraintlayout.widget.ConstraintLayout
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:fitsSystemWindows="false"
        android:id="@+id/parentlayout">

        <androidx.appcompat.widget.Toolbar
            android:id="@+id/chattoolbar"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            app:menu="@menu/chat_menu"
            android:background="@color/spirit"
            app:layout_constraintTop_toTopOf="parent"
            app:layout_constraintStart_toStartOf="parent"
            android:paddingEnd="10dp"
            android:theme="@style/ThemeOverlay.AppCompat.Dark.ActionBar"
            app:popupTheme="@style/ThemeOverlay.AppCompat.Light">

            <ImageView
                android:layout_width="35dp"
                android:layout_height="35dp"
                android:src="@drawable/back"
                android:id="@+id/back"
                android:layout_marginRight="8dp"/>

            <com.google.android.material.imageview.ShapeableImageView
                android:layout_width="35dp"
                android:layout_height="35dp"
                android:id="@+id/chatpic"
                app:shapeAppearanceOverlay="@style/circle_bg"
                android:src="@drawable/manprofile"
                android:scaleType="centerCrop"
                android:layout_marginEnd="8dp"/>

            <TextView
                android:id="@+id/viberTitle"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginStart="15dp"
                android:layout_marginBottom="12dp"
                android:text="Name"
                android:textColor="@android:color/white"
                android:textSize="20sp"
                android:textStyle="bold" />
        </androidx.appcompat.widget.Toolbar>

        <androidx.recyclerview.widget.RecyclerView
            android:id="@+id/chatrecyclerview"
            android:layout_width="match_parent"
            android:layout_height="0dp"
            app:layout_constraintTop_toBottomOf="@id/chattoolbar"
            app:layout_constraintBottom_toTopOf="@id/linearlayout"/>


        <androidx.constraintlayout.widget.ConstraintLayout
            android:id="@+id/linearlayout"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:padding="6dp"
            app:layout_constraintBottom_toBottomOf="parent">

            <EditText
                android:id="@+id/messagebox"
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:minHeight="50dp"
                android:maxLines="5"
                android:inputType="textMultiLine"
                android:background="@drawable/custom_edittext"
                android:hint="Type a message"
                android:paddingLeft="20dp"
                android:paddingTop="10dp"
                android:paddingRight="10dp"
                android:paddingBottom="10dp"
                android:scrollHorizontally="false"
                app:layout_constraintStart_toStartOf="parent"
                app:layout_constraintEnd_toStartOf="@id/sendbtn"
                app:layout_constraintBottom_toBottomOf="parent"/>

            <ImageView
                android:id="@+id/sendbtn"
                android:layout_width="50dp"
                android:layout_height="50dp"
                android:src="@drawable/send"
                android:background="?attr/selectableItemBackgroundBorderless"
                app:layout_constraintEnd_toEndOf="parent"
                app:layout_constraintBottom_toBottomOf="parent"/>

        </androidx.constraintlayout.widget.ConstraintLayout>



    </androidx.constraintlayout.widget.ConstraintLayout>

</androidx.constraintlayout.widget.ConstraintLayout>
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="vertical"
    android:padding="24dp"
    android:background="@drawable/bg_greeting_dialog">

    <TextView
        android:id="@+id/txtWelcome"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Welcome 👋"
        android:textSize="22sp"
        android:textStyle="bold"
        android:textColor="#0099FF"/>

    <TextView
        android:id="@+id/txtUsername"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="User Name"
        android:textSize="18sp"
        android:textColor="#666"
        android:layout_marginTop="8dp"/>

    <TextView
        android:id="@+id/txtAuthor"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Created by Sameer Nayak 💙"
        android:textSize="14sp"
        android:layout_marginTop="16dp"
        android:textColor="#666"/>

    <Button
        android:id="@+id/btnContinue"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="Continue"
        android:layout_marginTop="20dp"/>
</LinearLayout>

<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:id="@+id/main"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="#F2F2F2">

    <!-- Top Background -->
    <View
        android:id="@+id/topView"
        android:layout_width="0dp"
        android:layout_height="150dp"
        android:background="#0099FF"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <View
        android:id="@+id/waveView"
        android:layout_width="0dp"
        android:layout_height="100dp"
        android:background="@drawable/waves"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@id/topView" />

    <!-- Logo -->

    <ImageView
        android:id="@+id/logo"
        android:layout_width="85dp"
        android:layout_height="85dp"
        android:layout_marginTop="40dp"
        android:contentDescription="App logo"
        android:src="@drawable/viber_icon"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintHorizontal_bias="0.901"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <TextView
        android:id="@+id/title"
        android:layout_width="172dp"
        android:layout_height="139dp"
        android:layout_marginLeft="30dp"
        android:layout_marginTop="12dp"
        android:fontFamily="@font/myfont"
        android:gravity="start"
        android:text="Welcome\n Viber"
        android:textColor="@android:color/white"
        android:textSize="42sp"
        android:textStyle="bold"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <!-- Email input -->
    <EditText
        android:id="@+id/etemail"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginHorizontal="32dp"
        android:layout_marginTop="16dp"
        android:background="@drawable/round_border"
        android:drawableStart="@drawable/baseline_email_24"
        android:drawablePadding="12dp"
        android:hint="E-mail"
        android:inputType="textEmailAddress"
        android:padding="16dp"
        android:textColor="#000000"
        android:textColorHint="#9E9E9E"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@id/waveView" />


    <!-- Password input -->
    <com.google.android.material.textfield.TextInputLayout
        android:id="@+id/passwordLayout"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginHorizontal="32dp"
        android:layout_marginTop="16dp"
        android:background="@drawable/round_border"
        android:minHeight="48dp"
        android:textColorHint="#9E9E9E"
        android:textColor="#000000"
        app:boxBackgroundMode="none"
        app:endIconMode="password_toggle"
        app:endIconTint="@color/black"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@id/etemail">

        <com.google.android.material.textfield.TextInputEditText
            android:id="@+id/etpassword"
            android:layout_width="match_parent"
            android:layout_height="48dp"
            android:background="@android:color/transparent"
            android:drawableStart="@drawable/ic_lock"
            android:drawablePadding="12dp"
            android:hint="Password"
            android:inputType="textPassword"
            android:textColor="#000000"
            android:paddingStart="16dp"
            android:paddingTop="12dp"
            android:paddingEnd="48dp"
            android:paddingBottom="12dp" />
    </com.google.android.material.textfield.TextInputLayout>


    <!-- Sign In button -->
    <com.google.android.material.button.MaterialButton
        android:id="@+id/signinbtn"
        android:layout_width="0dp"
        android:layout_height="48dp"
        android:layout_marginHorizontal="32dp"
        android:layout_marginTop="24dp"
        android:background="@drawable/btn_green_round"
        android:text="SIGN IN"
        android:textColor="@android:color/white"
        android:textSize="18sp"
        android:textStyle="bold"
        app:backgroundTint="@null"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@id/passwordLayout" />


    <!-- OR separator -->
    <TextView
        android:id="@+id/orText"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginTop="16dp"
        android:text="OR"
        android:textColor="#6E6E6E"
        android:textSize="16sp"
        android:textStyle="bold"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@id/signinbtn" />

    <!-- Sign up link -->
    <TextView
        android:id="@+id/signupbtn"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginTop="24dp"
        android:text="New User? Register Now"
        android:textColor="#0099ff"
        android:textSize="16sp"
        android:textStyle="bold"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@id/orText" />

</androidx.constraintlayout.widget.ConstraintLayout>

<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/main"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    tools:context=".MainActivity">


    <androidx.appcompat.widget.Toolbar
        android:id="@+id/maintoolbar"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:background="@color/spirit"
        android:paddingTop="0dp"
        android:paddingBottom="0dp"
        android:theme="@style/ThemeOverlay.AppCompat.Dark.ActionBar"
        app:layout_constraintBottom_toTopOf="@+id/userrecyclerview"
        app:popupTheme="@style/ThemeOverlay.AppCompat.Light"
        app:titleMarginStart="30dp">

        <LinearLayout
            android:layout_width="wrap_content"
            android:layout_height="match_parent"
            android:gravity="center_vertical"
            android:orientation="horizontal"
            android:paddingTop="0dp"
            android:paddingBottom="0dp">

            <!-- Small logo -->
            <ImageView
                android:id="@+id/viberLogo"
                android:layout_width="28dp"
                android:layout_height="28dp"
                android:layout_marginEnd="8dp"
                android:adjustViewBounds="true"
                android:contentDescription="App Logo"
                android:scaleType="fitCenter"
                android:src="@drawable/viber_icon" />

            <!-- Title text -->
            <TextView
                android:id="@+id/viberTitle"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginStart="15dp"
                android:text="Viber"
                android:textColor="@android:color/white"
                android:textSize="25sp"
                android:textStyle="bold" />

        </LinearLayout>

    </androidx.appcompat.widget.Toolbar>


    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:gravity="center_vertical"
        android:orientation="horizontal"
        android:padding="8dp">

        <!-- Search Bar -->
        <androidx.appcompat.widget.SearchView
            android:id="@+id/search"
            android:layout_width="0dp"
            android:layout_height="44dp"
            android:layout_weight="1"
            android:background="@drawable/search_bkg"
            android:focusable="false"
            app:iconifiedByDefault="false"
            app:queryHint="Search"
            app:searchHintIcon="@null" />

        <!-- Status Button -->
        <androidx.appcompat.widget.AppCompatButton
            android:id="@+id/btnStatus"
            android:layout_width="wrap_content"
            android:layout_height="44dp"
            android:layout_marginStart="10dp"
            android:background="@drawable/status_btn_bg"
            android:backgroundTint="@null"
            android:text="My Vibes"
            android:textAllCaps="false"
            android:textColor="@android:color/white"
            android:textSize="14sp"
            android:textStyle="bold" />

    </LinearLayout>


    <androidx.recyclerview.widget.RecyclerView
        android:id="@+id/userrecyclerview"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        tools:listitem="@layout/user_layout" />

</LinearLayout>
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:id="@+id/main"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="#F2F2F2">

    <!-- Top Background -->
    <View
        android:id="@+id/topView"
        android:layout_width="0dp"
        android:layout_height="140dp"
        android:background="#0099FF"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintTop_toTopOf="parent"/>

    <View
        android:id="@+id/waveView"
        android:layout_width="0dp"
        android:layout_height="100dp"
        android:background="@drawable/waves"
        app:layout_constraintTop_toBottomOf="@id/topView"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent"/>

    <!-- Logo -->

    <!-- Title -->
    <ImageView
        android:id="@+id/logo"
        android:layout_width="75dp"
        android:layout_height="75dp"
        android:layout_marginTop="44dp"
        android:layout_marginEnd="36dp"
        android:src="@drawable/viber_icon"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <!-- Name -->

    <TextView
        android:id="@+id/title"
        android:layout_width="162dp"
        android:layout_height="145dp"
        android:layout_marginStart="32dp"
        android:layout_marginTop="4dp"
        android:fontFamily="@font/myfont"
        android:gravity="start"
        android:text="Create\nAccount"
        android:textColor="@android:color/white"
        android:textSize="42sp"
        android:textStyle="bold"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <EditText
        android:id="@+id/etname"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginHorizontal="32dp"
        android:layout_marginTop="16dp"
        android:background="@drawable/round_border"
        android:drawableStart="@drawable/name"
        android:drawablePadding="12dp"
        android:hint="Name"
        android:padding="16dp"
        android:textColor="#000000"
        android:textColorHint="#9E9E9E"
        app:layout_constraintTop_toBottomOf="@id/waveView"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent"/>

    <!-- Email -->
    <EditText
        android:id="@+id/etemail"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginHorizontal="32dp"
        android:layout_marginTop="16dp"
        android:background="@drawable/round_border"
        android:drawableStart="@drawable/baseline_email_24"
        android:drawablePadding="12dp"
        android:hint="E-mail"
        android:inputType="textEmailAddress"
        android:padding="16dp"
        android:textColor="#000000"
        android:textColorHint="#9E9E9E"
        app:layout_constraintTop_toBottomOf="@id/etname"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent"/>

    <!-- Password -->
    <com.google.android.material.textfield.TextInputLayout
        android:id="@+id/passwordLayout"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginHorizontal="32dp"
        android:layout_marginTop="16dp"
        android:background="@drawable/round_border"
        android:textColor="#000000"
        app:boxBackgroundMode="none"
        android:textColorHint="#9E9E9E"
        app:endIconMode="password_toggle"
        app:endIconTint="@color/black"
        app:layout_constraintTop_toBottomOf="@id/etemail"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent">

        <com.google.android.material.textfield.TextInputEditText
            android:id="@+id/etpassword"
            android:layout_width="match_parent"
            android:layout_height="48dp"
            android:background="@android:color/transparent"
            android:drawableStart="@drawable/ic_lock"
            android:drawablePadding="12dp"
            android:hint="Password"
            android:textColor="#000000"
            android:inputType="textPassword"
            android:paddingStart="16dp"
            android:paddingTop="12dp"
            android:paddingEnd="48dp"
            android:paddingBottom="12dp"/>
    </com.google.android.material.textfield.TextInputLayout>

    <!-- Phone -->
    <EditText
        android:id="@+id/etphone"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginHorizontal="32dp"
        android:layout_marginTop="16dp"
        android:background="@drawable/round_border"
        android:drawableStart="@drawable/phonenumber"
        android:drawablePadding="12dp"
        android:hint="Phone Number"
        android:inputType="phone"
        android:padding="16dp"
        android:textColor="#000000"
        android:textColorHint="#9E9E9E"
        app:layout_constraintTop_toBottomOf="@id/passwordLayout"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent"/>

    <!-- Sign Up Button -->
    <com.google.android.material.button.MaterialButton
        android:id="@+id/signupbtn"
        android:layout_width="0dp"
        android:layout_height="48dp"
        android:layout_marginHorizontal="32dp"
        android:layout_marginTop="24dp"
        android:text="SIGN UP"
        android:textSize="18sp"
        android:textStyle="bold"
        android:textColor="@android:color/white"
        android:background="@drawable/btn_green_round"
        app:backgroundTint="@null"
        app:layout_constraintTop_toBottomOf="@id/etphone"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent"/>

    <TextView
        android:id="@+id/loginText"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Already have an account? Login"
        android:textColor="#0099FF"
        android:textSize="16sp"
        android:textStyle="bold"
        android:layout_marginTop="16dp"
        app:layout_constraintTop_toBottomOf="@id/signupbtn"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent"/>


</androidx.constraintlayout.widget.ConstraintLayout>

<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:id="@+id/main"
    android:background="#0099FF">

    <LinearLayout
        android:layout_centerInParent="true"
        android:orientation="vertical"
        android:gravity="center"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content">

        <ImageView
            android:layout_width="100dp"
            android:layout_height="100dp"
            android:src="@drawable/viber_icon" />

        <TextView
            android:layout_marginTop="12dp"
            android:text="Viber"
            android:textSize="22sp"
            android:textStyle="bold"
            android:textColor="#FFFFFF"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"/>

        <TextView
            android:text="by Sameer Nayak"
            android:textSize="14sp"
            android:textColor="#E0E0E0"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"/>
    </LinearLayout>

</RelativeLayout>

<?xml version="1.0" encoding="utf-8"?>
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:gravity="center">

    <com.google.android.material.card.MaterialCardView
        android:layout_width="330dp"
        android:layout_height="wrap_content"
        android:layout_margin="20dp"
        app:cardCornerRadius="28dp"
        app:cardElevation="12dp"
        app:cardBackgroundColor="@android:color/white">


    <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="vertical"
            android:padding="26dp"
            android:gravity="center_horizontal">

            <!-- Profile Image with Ring -->
            <com.google.android.material.imageview.ShapeableImageView
                android:id="@+id/userrprofile"
                android:layout_width="120dp"
                android:layout_height="120dp"
                android:src="@drawable/manprofile"
                android:scaleType="centerCrop"
                android:padding="3dp"
                android:background="@drawable/profile_ring"
                app:shapeAppearanceOverlay="@style/circleimagestyle"/>

            <!-- Name -->
            <TextView
                android:id="@+id/profilename"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="Sameer Nayak"
                android:textSize="22sp"
                android:textStyle="bold"
                android:textColor="#1F1F1F"
                android:layout_marginTop="12dp"/>

            <!-- Subtitle -->
            <TextView
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="Hey there! I am using Viber"
                android:textSize="14sp"
                android:textColor="#6E6E6E"
                android:layout_marginTop="4dp"/>

            <!-- Save Button -->
            <Button
                android:id="@+id/btnsave"
                android:layout_width="match_parent"
                android:layout_height="48dp"
                android:text="Save Profile"
                android:textSize="16sp"
                android:textStyle="bold"
                android:textColor="@android:color/white"
                android:layout_marginTop="24dp"
                android:background="@drawable/btn_green_round"
                app:backgroundTint="@null" />

        </LinearLayout>

    </com.google.android.material.card.MaterialCardView>

</FrameLayout>

<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="vertical"
    android:padding="24dp"
    android:background="@drawable/dialog_bg_round">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Logout"
        android:textSize="20sp"
        android:textStyle="bold"
        android:textColor="#1F1F1F"/>

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Are you sure you want to logout?"
        android:textSize="14sp"
        android:textColor="#6E6E6E"
        android:layout_marginTop="8dp"/>

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        android:gravity="end"
        android:layout_marginTop="24dp">

        <TextView
            android:id="@+id/btnCancel"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Cancel"
            android:textSize="14sp"
            android:textColor="#6E6E6E"
            android:padding="12dp"/>

        <TextView
            android:id="@+id/btnLogout"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Logout"
            android:textSize="14sp"
            android:textStyle="bold"
            android:textColor="#25D366"
            android:padding="12dp"/>
    </LinearLayout>

</LinearLayout>

<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:gravity="start"
    android:paddingStart="8dp"
    android:paddingEnd="48dp"
    android:paddingTop="4dp"
    android:paddingBottom="4dp">

    <LinearLayout
        android:id="@+id/receive_container"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:background="@drawable/bg_receive_message"
        android:orientation="vertical"
        android:padding="12dp"
        android:elevation="4dp">

        <TextView
            android:id="@+id/txt_receive_msg"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:maxWidth="280dp"
            android:textColor="#1F1F1F"
            android:textSize="16sp"
            android:lineSpacingExtra="4dp"
            android:text="This is a received message styled like WhatsApp." />
    </LinearLayout>

</LinearLayout>

<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:gravity="end"
    android:paddingStart="48dp"
    android:paddingEnd="8dp"
    android:paddingTop="4dp"
    android:paddingBottom="4dp">

    <LinearLayout
        android:id="@+id/sent_container"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:background="@drawable/bg_sent_message"
        android:orientation="vertical"
        android:padding="12dp"
        android:elevation="4dp">

        <TextView
            android:id="@+id/txt_sent_msg"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:maxWidth="280dp"
            android:textColor="@android:color/white"
            android:textSize="16sp"
            android:lineSpacingExtra="4dp"
            android:text="This is a sent message that looks like WhatsApp and wraps nicely." />
    </LinearLayout>

</LinearLayout>

<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="72dp"
    android:orientation="horizontal"
    android:gravity="center_vertical"
    android:paddingStart="8dp"
    android:paddingEnd="16dp"
    android:background="?attr/selectableItemBackground"
    android:clickable="true"
    android:focusable="true">

    <!-- Profile Image -->
    <com.google.android.material.imageview.ShapeableImageView
        android:id="@+id/profileid"
        android:layout_width="50dp"
        android:layout_height="50dp"
        android:scaleType="centerCrop"
        android:src="@drawable/manprofile"
        app:shapeAppearanceOverlay="@style/circleimagestyle" />

    <!-- Name & Message Container -->
    <LinearLayout
        android:id="@+id/llname"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginStart="14dp"
        android:layout_weight="1"
        android:orientation="vertical">

        <!-- User Name -->
        <TextView
            android:id="@+id/txt_name"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Sameer"
            android:textSize="18sp"
            android:textStyle="bold"
            android:textColor="@android:color/black" />

        <!-- Last Message -->
        <TextView
            android:id="@+id/txt_last_message"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Hey! How are you?"
            android:textSize="16sp"
            android:textColor="#6E6E6E"
            android:maxLines="1"
            android:ellipsize="end"/>
    </LinearLayout>

    <!-- Right Side Container -->
    <LinearLayout
        android:layout_width="wrap_content"
        android:layout_height="match_parent"
        android:orientation="vertical"
        android:gravity="center_vertical|end">

        <!-- Message Time (optional) -->
        <TextView
            android:id="@+id/txt_time"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="12:45 PM"
            android:textSize="12sp"
            android:textColor="#6E6E6E"
            android:layout_marginBottom="6dp"/>

        <!-- Unread Message Count Badge -->
        <TextView
            android:id="@+id/txt_unread_count"
            android:layout_width="22dp"
            android:layout_height="22dp"
            android:background="@drawable/unread_show"
            android:gravity="center"
            android:text="3"
            android:textColor="@android:color/white"
            android:textSize="12sp"
            android:textStyle="bold"
            android:visibility="visible"/>
    </LinearLayout>

</LinearLayout>

<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto">

    <item
        android:id="@+id/call"
        android:icon="@drawable/baseline_call_24"
        app:showAsAction="always"
        android:title="Call"/>

</menu>
<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto">

    <item
        android:id="@+id/profilepic"
        android:title="Profile"
        app:showAsAction="never"/>

    <item
        android:id="@+id/theme"
        android:title="Themes"
        app:showAsAction="never">

        <menu>
            <item
                android:id="@+id/light"
                android:title="Light"/>

            <item
                android:id="@+id/dark"
                android:title="Dark"/>
        </menu>
    </item>

    <item
        android:id="@+id/menu"
        android:title="Logout"
        app:showAsAction="never"/>

</menu>
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
<resources xmlns:tools="http://schemas.android.com/tools">
    <!-- Base application theme. -->
    <style name="Base.Theme.Viber" parent="Theme.Material3.DayNight.NoActionBar">
        <!-- Customize your dark theme here. -->
        <!-- <item name="colorPrimary">@color/my_dark_primary</item> -->
    </style>
</resources>
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="black">#FF000000</color>
    <color name="white">#FFFFFFFF</color>
    <color name="spirit">#15A38C</color>
    <color name="darktheme">#121212</color>
    <color name="chat1">#EDECD9</color>
    <color name="chat2">#C0C0C0</color>

</resources>
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#0099FF</color>
</resources>
<resources>
    <string name="app_name">Viber</string>
</resources>
<?xml version="1.0" encoding="utf-8"?>
<resources>
    
    <style name="circleimagestyle">
        <item name="cornerFamily">rounded</item>
        <item name="cornerSize">50%</item>
    </style>


</resources>
<resources xmlns:tools="http://schemas.android.com/tools">
    <!-- Base application theme. -->
    <style name="Base.Theme.Viber" parent="Theme.AppCompat.DayNight.NoActionBar">
        <!-- Customize your light theme here. -->
        <!-- <item name="colorPrimary">@color/my_light_primary</item> -->
    </style>

    <!-- Light Toolbar -->
    <style name="ToolbarLight" parent="ThemeOverlay.AppCompat.Light">
        <item name="android:textColorPrimary">@android:color/black</item>
    </style>

    <!-- Dark Toolbar -->
    <style name="ToolbarDark" parent="ThemeOverlay.AppCompat.Dark.ActionBar">
        <item name="android:textColorPrimary">@android:color/white</item>
    </style>

    <style name="Theme.Viber" parent="Theme.MaterialComponents.DayNight.NoActionBar">
        <!-- optional colors -->
        <item name="colorPrimary">#0099FF</item>
    </style>

    <style name="Theme.Viber.Launcher" parent="Theme.MaterialComponents.DayNight.NoActionBar">

        <!-- THIS REMOVES BLACK SCREEN + ANDROID ICON -->
        <item name="android:windowBackground">@drawable/splash_bg</item>
        <item name="windowSplashScreenAnimatedIcon">@null</item>

        <item name="android:windowFullscreen">true</item>
        <item name="android:windowDrawsSystemBarBackgrounds">true</item>

    </style>

</resources>
<?xml version="1.0" encoding="utf-8"?><!--
   Sample backup rules file; uncomment and customize as necessary.
   See https://developer.android.com/guide/topics/data/autobackup
   for details.
   Note: This file is ignored for devices older than API 31
   See https://developer.android.com/about/versions/12/backup-restore
-->
<full-backup-content>
    <!--
   <include domain="sharedpref" path="."/>
   <exclude domain="sharedpref" path="device.xml"/>
-->
</full-backup-content>
<?xml version="1.0" encoding="utf-8"?><!--
   Sample data extraction rules file; uncomment and customize as necessary.
   See https://developer.android.com/about/versions/12/backup-restore#xml-changes
   for details.
-->
<data-extraction-rules>
    <cloud-backup>
        <!-- TODO: Use <include> and <exclude> to control what is backed up.
        <include .../>
        <exclude .../>
        -->
    </cloud-backup>
    <!--
    <device-transfer>
        <include .../>
        <exclude .../>
    </device-transfer>
    -->
</data-extraction-rules>
package com.example.viber

import org.junit.Test

import org.junit.Assert.*

/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * See [testing documentation](http://d.android.com/tools/testing).
 */
class ExampleUnitTest {
    @Test
    fun addition_isCorrect() {
        assertEquals(4, 2 + 2)
    }
}

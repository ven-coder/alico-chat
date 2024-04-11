package com.alico.chat.app.common

import java.util.*
import kotlin.random.Random

object DefaultUserInfo {
    val maleAvatarList = arrayListOf(
        "/image/avatar/male/male_avatar_1.jpg",
        "/image/avatar/male/male_avatar_2.jpg",
        "/image/avatar/male/male_avatar_3.jpg",
        "/image/avatar/male/male_avatar_4.jpg",
        "/image/avatar/male/male_avatar_5.jpg",
        "/image/avatar/male/male_avatar_6.jpg",
        "/image/avatar/male/male_avatar_7.jpg",
        "/image/avatar/male/male_avatar_8.jpg",
        "/image/avatar/male/male_avatar_9.jpg",
        "/image/avatar/male/male_avatar_10.jpg",
        "/image/avatar/male/male_avatar_11.jpg",
        "/image/avatar/male/male_avatar_12.jpg",
        "/image/avatar/male/male_avatar_13.jpg",
        "/image/avatar/male/male_avatar_14.jpg",
        "/image/avatar/male/male_avatar_15.jpg",
        "/image/avatar/male/male_avatar_16.jpg",
        "/image/avatar/male/male_avatar_17.jpg",
        "/image/avatar/male/male_avatar_18.jpg",
    );

    val femaleAvatarList = arrayListOf(
        "/image/avatar/female/female_avatar_1.jpg",
        "/image/avatar/female/female_avatar_2.jpg",
        "/image/avatar/female/female_avatar_3.jpg",
        "/image/avatar/female/female_avatar_4.jpg",
        "/image/avatar/female/female_avatar_5.jpg",
        "/image/avatar/female/female_avatar_6.jpg",
        "/image/avatar/female/female_avatar_7.jpg",
        "/image/avatar/female/female_avatar_8.jpg",
        "/image/avatar/female/female_avatar_9.jpg",
        "/image/avatar/female/female_avatar_10.jpg",
        "/image/avatar/female/female_avatar_11.jpg",
        "/image/avatar/female/female_avatar_12.jpg",
        "/image/avatar/female/female_avatar_13.jpg",
        "/image/avatar/female/female_avatar_14.jpg",
        "/image/avatar/female/female_avatar_15.jpg",
        "/image/avatar/female/female_avatar_16.jpg",
        "/image/avatar/female/female_avatar_17.jpg",
        "/image/avatar/female/female_avatar_18.jpg",
    );

    fun getRandomMaleAvatar(): String {

        val value = Random.nextInt(maleAvatarList.size)
        return maleAvatarList[value]

    }

    fun getRandomFemaleAvatar(): String {

        val value = Random.nextInt(femaleAvatarList.size)
        return femaleAvatarList[value]

    }

    fun generateRandomNickname(): String {
        val alphabet = ('a'..'z')
        val name = StringBuilder()

        repeat(Random.nextInt(5) + 3) {
            val randomIndex = Random.nextInt(alphabet.count())
            name.append(alphabet.elementAt(randomIndex))
        }

        return name.toString().replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() }
    }
}
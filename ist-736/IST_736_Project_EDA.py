#!/Users/niranjanjuvekar/opt/anaconda3/bin/python3

# from google.colab import files
# import io


import pandas as pd
# uploaded = files.upload()

df = pd.read_csv ('Tweets.csv')

# print(df)

#checking null values
# print('sentiment null:',df['sentiment'].isnull().sum())
# print('text null:',df['text'].isnull().sum())

#Finding the null index number
x= df['text'].isnull()
i=0
for item in x:
    if item is False:
        i=i+1
    if item is True:
        break
# print(i)


# Dropping the row 
df.drop([314], inplace = True)


#checking the number of sentiment and finding the baseline
# print(df['sentiment'].value_counts())
# print('baseline',11118/sum(df['sentiment'].value_counts()))


# splitting the data
y=df['sentiment'].values
X=df['text'].values


positive_df = df.loc[df['sentiment'] == 'positive']
# print(positive_df)

negative_df = df.loc[df['sentiment'] == 'negative']
# print(negative_df)

neutral_df = df.loc[df['sentiment'] == 'neutral']
# print(neutral_df)


positiveText = ' '.join(positive_df["text"])
negativeText = ' '.join(negative_df["text"])
neutralText = ' '.join(neutral_df["text"])
allText      = ' '.join(df["text"])

from wordcloud import WordCloud
import matplotlib.pyplot as plt
from wordcloud import STOPWORDS
from PIL import Image
import numpy as np
from wordcloud import ImageColorGenerator

mask = np.array(Image.open('/Users/niranjanjuvekar/MyStuff/Education_Niranjan/Data_Science_Syracuse_University/09_IST_736/IST_736_Project/TwitterGreen.png'))
mask_colors = ImageColorGenerator(mask)
wc = WordCloud(stopwords=STOPWORDS, 
               mask=mask, background_color="white",
               max_words=2000, max_font_size=256,
               random_state=42, width=mask.shape[1],
               height=mask.shape[0], color_func=mask_colors)
cloud = wc.generate(positiveText)
plt.title('Wordcloud of Positive Tweets')
# plt.savefig('WordcloudPositiveTweets.png')
cloud.to_file('WordcloudPositiveTweets.png')
plt.imshow(wc, interpolation="bilinear")
plt.axis('off')
# plt.show()


mask = np.array(Image.open('/Users/niranjanjuvekar/MyStuff/Education_Niranjan/Data_Science_Syracuse_University/09_IST_736/IST_736_Project/TwitterRed.png'))
mask_colors = ImageColorGenerator(mask)
wc = WordCloud(stopwords=STOPWORDS, 
               mask=mask, background_color="white",
               max_words=2000, max_font_size=256,
               random_state=42, width=mask.shape[1],
               height=mask.shape[0], color_func=mask_colors)
cloud = wc.generate(negativeText)
plt.title('Wordcloud of Negative Tweets')
# plt.savefig('WordcloudNegativeTweets.png')
cloud.to_file('WordcloudNegativeTweets.png')
plt.imshow(wc, interpolation="bilinear")
plt.axis('off')
# plt.show()



mask = np.array(Image.open('/Users/niranjanjuvekar/MyStuff/Education_Niranjan/Data_Science_Syracuse_University/09_IST_736/IST_736_Project/TwitterBlue.png'))
mask_colors = ImageColorGenerator(mask)
wc = WordCloud(stopwords=STOPWORDS, 
               mask=mask, background_color="white",
               max_words=2000, max_font_size=256,
               random_state=42, width=mask.shape[1],
               height=mask.shape[0], color_func=mask_colors)
cloud = wc.generate(allText)
plt.title('Wordcloud of All Tweets')
# plt.savefig('WordcloudAllTweets.png')
cloud.to_file('WordcloudAllTweets.png')
plt.imshow(wc, interpolation="bilinear")
plt.axis('off')
# plt.show()


print("WordCount")
positive_df['WordCount'] = positive_df['text'].str.count(' ') + 1
negative_df['WordCount'] = negative_df['text'].str.count(' ') + 1
neutral_df['WordCount'] = neutral_df['text'].str.count(' ') + 1

print(positive_df['WordCount'])
print(negative_df['WordCount'])
print(neutral_df['WordCount'])

plt.clf()
plt.hist(positive_df['WordCount'], bins=20, range=(0, 40))
plt.ylim(0, 1300)
plt.title('Histogram of Word Count in Positive Tweets')
plt.savefig("positive_df_WordCount.png")

plt.clf()
plt.hist(negative_df['WordCount'], bins=20, range=(0, 40))
plt.ylim(0, 1300)
plt.title('Histogram of Word Count in Negative Tweets')
plt.savefig("negative_df_WordCount.png")

plt.clf()
plt.hist(neutral_df['WordCount'], bins=20, range=(0, 40))
plt.ylim(0, 1300)
plt.title('Histogram of Word Count in Neutral Tweets')
plt.savefig("neutral_df_WordCount.png")




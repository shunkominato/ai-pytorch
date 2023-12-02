from typing import Union, List
import ftfy, html, re, io
import requests
from PIL import Image
import torch
from transformers import AutoModel, AutoTokenizer, AutoImageProcessor, BatchFeature
emotions = [
    "嬉しい", "悲しい", "怒り", "驚き", "恐い",
    "恥ずかしい", "ストレス",
    "嫌悪", "不安", 
]
# taken from https://github.com/mlfoundations/open_clip/blob/main/src/open_clip/tokenizer.py#L65C8-L65C8
def basic_clean(text):
    text = ftfy.fix_text(text)
    text = html.unescape(html.unescape(text))
    return text.strip()

def whitespace_clean(text):
    text = re.sub(r"\s+", " ", text)
    text = text.strip()
    return text

def tokenize(
    tokenizer,
    texts: Union[str, List[str]],
    max_seq_len: int = 77,
):
    """
    This is a function that have the original clip's code has.
    https://github.com/openai/CLIP/blob/main/clip/clip.py#L195
    """
    if isinstance(texts, str):
        texts = [texts]
    texts = [whitespace_clean(basic_clean(text)) for text in texts]

    inputs = tokenizer(
        texts,
        max_length=max_seq_len - 1,
        padding="max_length",
        truncation=True,
        add_special_tokens=False,
    )
    # add bos token at first place
    input_ids = [[tokenizer.bos_token_id] + ids for ids in inputs["input_ids"]]
    attention_mask = [[1] + am for am in inputs["attention_mask"]]
    position_ids = [list(range(0, len(input_ids[0])))] * len(texts)

    return BatchFeature(
        {
            "input_ids": torch.tensor(input_ids, dtype=torch.long),
            "attention_mask": torch.tensor(attention_mask, dtype=torch.long),
            "position_ids": torch.tensor(position_ids, dtype=torch.long),
        }
    )

device = "cuda" if torch.cuda.is_available() else "cpu"
model_path = "stabilityai/japanese-stable-clip-vit-l-16"
access_token = ""
model = AutoModel.from_pretrained(model_path, trust_remote_code=True, token=access_token).to(device)
tokenizer = AutoTokenizer.from_pretrained(model_path, token=access_token)
processor = AutoImageProcessor.from_pretrained(model_path, token=access_token)

# Run!
image = Image.open('./16.webp')
image = processor(images=image, return_tensors="pt").to(device)
text = tokenize(
    tokenizer=tokenizer,
    texts=emotions
).to(device)

with torch.no_grad():
    image_features = model.get_image_features(**image)
    text_features = model.get_text_features(**text)
    text_probs = (image_features @ text_features.T).softmax(dim=-1)
    torch.set_printoptions(precision=3)
    text_probs_percent = text_probs * 100

# 各感情に対する確率を出力
for i, emotion in enumerate(emotions):
    print(f"{emotion}: {text_probs_percent[0][i].item():.3f}")

# [[1.0, 0.0, 0.0]]

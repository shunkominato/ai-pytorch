import torch
from PIL import Image
from transformers import CLIPProcessor, CLIPModel



# torch.matmul(text_embeds, image_embeds.t())


emotions = ["喜び", "悲しみ", "怒り", "驚き", "恐怖", "嫌悪"]
print('11111111')
model = CLIPModel.from_pretrained("openai/clip-vit-base-patch32")
print('222222222')
processor = CLIPProcessor.from_pretrained("openai/clip-vit-base-patch32")
print('3333')

image = Image.open("./1.jpg")
print('4444')
inputs = processor(text=emotions, images=image, return_tensors="pt", padding=True)
print('5555')
outputs = model(**inputs)
print('66666')

logits_per_image = outputs.logits_per_image

probs = logits_per_image.softmax(dim=1)

for i, emotion in enumerate(emotions):
    print(f"{emotion}: {probs[0][i].item()}")

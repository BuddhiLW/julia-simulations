using Images, FileIO
using Images, ImageEdgeDetection, Noise
using ImageEdgeDetection: Percentile
# using Plots  # ImageInTerminal
using ImageView, MosaicViews, ImageCore, ImageShow, TestImages, ColorVectorSpace
# specify the path to your local image file
img_path = "./img1.png"
img = load(img_path)

# # backends such as ImageMagick are required
img2 = testimage("mandrill")

# imshow(mosaicview(img, img2; nrow=1))



# alg = Canny(spatial_scale=1, high=Percentile(80), low=Percentile(20))

# edges = detect_edges(img, alg)
# imshow(mosaicview(img, edges; nrow=1))
# save("Cunny-1.png", mosaicview(img, edges; nrow=1),)


cameraman = testimage("cameraman")
canny(σ) = Canny(spatial_scale=σ, high=Percentile(80), low=Percentile(20))
simple_results = map(σ -> detect_edges(img, canny(σ)), 1:5)
# img_results = map(σ -> detect_edges(img2, canny(σ)), 1:5)
cameraman_results = map(σ -> detect_edges(cameraman, canny(σ)), 1:5)

# imshow(mosaicview(
#     mosaicview(img, cameraman),
#     map(mosaicview, simple_results, cameraman_results)...;
#     nrow=1
# ))

imshow(
)

save("Cunny-2.png",
    mosaicview(
        mosaicview(img, cameraman),
        map(mosaicview, simple_results, cameraman_results)...;
        nrow=1
    )
)

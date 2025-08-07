# Lab 2: Computer Vision with Octave

This laboratory exercise implements 14 comprehensive computer vision functions using Octave, covering fundamental image processing techniques from basic operations to advanced enhancement methods.

## 📁 Directory Structure

```
Lab2/
├── Q1_image_import.m           # Multi-format image import with colormaps
├── Q2_image_resize.m           # Aspect-ratio preserving resizing
├── Q3_grayscale_conversion.m   # Multiple grayscale conversion methods
├── Q4_image_crop.m             # Region-of-interest cropping
├── Q5_interpolation_techniques.m # Interpolation methods comparison
├── Q6_image_rotation.m         # Image rotation with canvas adjustment
├── Q7_image_download.m         # URL-based image downloading
├── Q8_camera_capture.m         # Camera capture simulation
├── Q9_color_spaces.m           # Color space analysis
├── Q10_image_metadata.m        # Metadata extraction and analysis
├── Q11_pixel_operations.m      # Mathematical pixel transformations
├── Q12_resolution_analysis.m   # Resolution impact analysis
├── Q13_colorspace_processing.m # Color space effects on processing
├── Q14_image_enhancement.m     # Advanced enhancement techniques
├── run_all_tests.m             # Comprehensive test runner
├── README.md                   # This documentation
└── images/                     # Test images and results
    ├── test_images/            # Input test images
    ├── downloaded/             # Downloaded images
    └── *.jpg, *.png            # Generated result images
```

## 🚀 Quick Start

1. **Setup Test Images**: Place your test images in `Lab2/images/test_images/` or run the test script to generate sample images automatically.

2. **Run All Tests**:
   ```octave
   cd Lab2
   run_all_tests
   ```

3. **Run Individual Functions**:
   ```octave
   % Example: Test image enhancement
   Q14_image_enhancement('images/test_images/dark_image.jpg');
   
   % Example: Test color space analysis
   Q9_color_spaces('images/test_images/colorful.jpg');
   ```

## 📋 Required Test Images

Place the following images in `Lab2/images/test_images/`:

| Filename | Type | Purpose |
|----------|------|---------|
| `portrait.png` | Person photo | General testing |
| `landscape.jpg` | Nature landscape | Resizing, cropping |
| `object.bmp` | Simple object | Format testing |
| `high_resolution.jpg` | Large detailed image | Resolution analysis |
| `geometric.png` | Geometric shapes | Rotation testing |
| `colorful.jpg` | Very colorful image | Color space analysis |
| `with_metadata.jpg` | Camera-taken photo | Metadata extraction |
| `low_res.jpg` | Small resolution | Resolution comparison |
| `dark_image.jpg` | Dark/low contrast | Enhancement testing |

*Note: If images are missing, the test runner will automatically generate synthetic test images.*

## 🔧 Function Descriptions

### Q1: Image Import (`Q1_image_import.m`)
- **Purpose**: Import multiple image formats and display with different colormaps
- **Features**: 
  - Supports PNG, JPEG, BMP, TIFF, GIF formats
  - Multiple colormap demonstrations (grayscale, hot, jet, cool)
  - Error handling for invalid formats
  - Visual perception analysis
- **Usage**: `Q1_image_import('images/test_images/')`

### Q2: Image Resize (`Q2_image_resize.m`)
- **Purpose**: Resize images while maintaining aspect ratio
- **Features**:
  - Automatic aspect ratio calculation
  - Quality vs. compression analysis
  - Side-by-side comparison visualization
  - Performance metrics
- **Usage**: `Q2_image_resize('image.jpg', 400, 300)`

### Q3: Grayscale Conversion (`Q3_grayscale_conversion.m`)
- **Purpose**: Compare different grayscale conversion methods
- **Methods**:
  - Average method
  - Luminosity method (standard RGB weights)
  - Desaturation method
  - Single channel extraction
  - Custom weighted average
- **Usage**: `Q3_grayscale_conversion('colorful_image.jpg')`

### Q4: Image Crop (`Q4_image_crop.m`)
- **Purpose**: Crop images to specific regions of interest
- **Features**:
  - Coordinate validation
  - Interactive cropping helper
  - Area analysis and statistics
  - Visual feedback with bounding boxes
- **Usage**: `Q4_image_crop('image.jpg', [100, 100], [400, 300])`

### Q5: Interpolation Techniques (`Q5_interpolation_techniques.m`)
- **Purpose**: Compare interpolation methods for image resizing
- **Methods**:
  - Nearest neighbor
  - Bilinear interpolation
  - Bicubic interpolation
  - Lanczos interpolation (if available)
- **Analysis**: Speed vs. quality trade-offs, edge preservation
- **Usage**: `Q5_interpolation_techniques('image.png', 2.0)`

### Q6: Image Rotation (`Q6_image_rotation.m`)
- **Purpose**: Rotate images by any angle with size handling
- **Features**:
  - Multiple rotation modes (crop, loose, custom)
  - Geometric analysis and visualization
  - Size and aspect ratio calculations
  - Mathematical transformation analysis
- **Usage**: `Q6_image_rotation('image.png', 45)`

### Q7: Image Download (`Q7_image_download.m`)
- **Purpose**: Download images from URLs with robust error handling
- **Features**:
  - Multiple download methods (urlwrite, websave, curl, wget)
  - Format detection and validation
  - Comprehensive error handling
  - Image analysis after download
- **Usage**: `Q7_image_download({'https://example.com/image.jpg'})`

### Q8: Camera Capture (`Q8_camera_capture.m`)
- **Purpose**: Simulate camera capture with parameter adjustment
- **Features**:
  - Multiple capture methods
  - Brightness and contrast adjustment
  - Simulated capture for testing
  - Parameter effect demonstration
- **Usage**: `Q8_camera_capture(1, 60, 55)`

### Q9: Color Spaces (`Q9_color_spaces.m`)
- **Purpose**: Analyze and display images in different color spaces
- **Color Spaces**:
  - RGB (Red, Green, Blue)
  - HSV (Hue, Saturation, Value)
  - YCbCr (Luminance, Chrominance)
  - LAB (Lightness, A, B)
  - Individual channel analysis
- **Usage**: `Q9_color_spaces('colorful_image.jpg')`

### Q10: Image Metadata (`Q10_image_metadata.m`)
- **Purpose**: Extract and analyze comprehensive image metadata
- **Features**:
  - EXIF data extraction (multiple methods)
  - File properties analysis
  - Color and quality metrics
  - Histogram analysis
  - Metadata importance discussion
- **Usage**: `metadata = Q10_image_metadata('photo.jpg')`

### Q11: Pixel Operations (`Q11_pixel_operations.m`)
- **Purpose**: Apply mathematical operations to pixel values
- **Operations**:
  - Scaling (brightness adjustment)
  - Translation (offset operations)
  - Gamma correction
  - Logarithmic transformation
  - Power law transformation
  - Piecewise linear transformation
  - Histogram operations
  - Bitwise operations
- **Usage**: `Q11_pixel_operations('image.png')`

### Q12: Resolution Analysis (`Q12_resolution_analysis.m`)
- **Purpose**: Analyze how resolution affects processing tasks
- **Features**:
  - Resolution pyramid creation
  - Processing speed analysis
  - Memory usage assessment
  - Quality vs. performance trade-offs
  - Practical recommendations
- **Usage**: `Q12_resolution_analysis('high_res.jpg', 'low_res.jpg')`

### Q13: Color Space Processing (`Q13_colorspace_processing.m`)
- **Purpose**: Demonstrate color space effects on image processing
- **Applications**:
  - Edge detection in different color spaces
  - Segmentation performance comparison
  - Color-based operations (masking, skin detection)
  - Performance and quality analysis
- **Usage**: `Q13_colorspace_processing('image.jpg')`

### Q14: Image Enhancement (`Q14_image_enhancement.m`)
- **Purpose**: Apply and compare various enhancement techniques
- **Techniques**:
  - Histogram equalization
  - Contrast stretching
  - CLAHE (Contrast Limited Adaptive Histogram Equalization)
  - Gamma correction
  - Logarithmic enhancement
  - Unsharp masking
  - Multi-scale enhancement
  - Retinex enhancement
- **Usage**: `Q14_image_enhancement('dark_image.jpg')`

## 📊 Output Files

Each function generates various output files in `Lab2/images/`:

- **Processed Images**: Results of each operation
- **Comparison Images**: Side-by-side comparisons
- **Analysis Charts**: Performance and quality metrics
- **Metadata Files**: Extracted information in text format

Example output files:
```
Lab2/images/
├── resized_landscape_400x300.jpg
├── gray_luminosity_colorful.jpg
├── cropped_portrait_150x100.png
├── interp_bicubic_geometric_2.0x.jpg
├── rotated_loose_geometric_45deg.jpg
├── edges_canny_hsv_colorful.jpg
├── enhanced_clahe_dark_image.jpg
└── metadata_photo.txt
```

## 🔍 Quality Metrics

The functions implement various quality assessment metrics:

- **Sharpness**: Gradient magnitude analysis
- **Contrast**: Standard deviation of intensities
- **Entropy**: Information content measurement
- **Dynamic Range**: Intensity span analysis
- **Edge Density**: Percentage of edge pixels
- **Color Diversity**: Unique color count
- **Processing Speed**: Execution time measurement

## 🛠️ Dependencies

**Required Octave Packages**:
- `image` package (for advanced image processing)
- `signal` package (for filtering operations)

**Optional System Tools**:
- `curl` or `wget` (for image downloading)
- `exiftool` (for enhanced metadata extraction)
- `ffmpeg` (for camera capture on some systems)

**Install packages**:
```octave
pkg install -forge image
pkg install -forge signal
pkg load image
pkg load signal
```

## 🎯 Learning Objectives

Upon completion, you will understand:

1. **Image Representation**: Different formats, color spaces, and data types
2. **Geometric Operations**: Resizing, rotation, cropping with quality considerations
3. **Color Processing**: Color space conversions and their applications
4. **Enhancement Techniques**: Various methods to improve image quality
5. **Performance Analysis**: Speed vs. quality trade-offs in image processing
6. **Practical Applications**: Real-world computer vision techniques

## 📈 Performance Considerations

- **Memory Usage**: Large images may require significant RAM
- **Processing Speed**: Complex operations may take time on large images
- **Quality vs. Speed**: Different algorithms offer various trade-offs
- **Storage**: Generated images require disk space

## 🔧 Troubleshooting

**Common Issues**:

1. **Missing Images**: Run `run_all_tests.m` to generate sample images
2. **Package Errors**: Install required Octave packages
3. **Memory Issues**: Use smaller images or increase system memory
4. **Display Problems**: Ensure graphics system is properly configured

**Error Messages**:
- "Image file not found": Check file paths and ensure images exist
- "Package not available": Install required Octave packages
- "Out of memory": Use smaller images or process in segments

## 📚 Additional Resources

- **Octave Image Package Documentation**: https://octave.sourceforge.io/image/
- **Computer Vision Fundamentals**: Study image processing theory
- **Color Space References**: Learn about different color representations
- **Enhancement Techniques**: Research advanced image enhancement methods

## 🏆 Assessment Criteria

Functions are evaluated on:

1. **Correctness**: Proper implementation of algorithms
2. **Robustness**: Error handling and edge cases
3. **Documentation**: Clear comments and user feedback
4. **Performance**: Efficient implementation
5. **Visualization**: Clear and informative displays
6. **Analysis**: Meaningful quality assessments

## 📝 Notes

- All functions include comprehensive error handling
- Detailed console output explains each processing step
- Generated visualizations help understand algorithm behavior
- Modular design allows easy extension and modification
- Cross-platform compatibility with fallback methods

---

**Author**: AI Assistant  
**Course**: Computer Vision Laboratory  
**Lab**: 2 - Image Processing with Octave  
**Date**: 2024
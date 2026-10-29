/* Copyright 2009-2010 The MathWorks, Inc. */
#ifndef __SL_DATATYPE_ACCESS__
#define __SL_DATATYPE_ACCESS__

#ifndef _DATA_TYPE_ACCESS
#define _DATA_TYPE_ACCESS
   /*
    * Use incomplete type for function prototypes within DataTypeAccess itself
    */
   typedef struct _slDataTypeAccess_tag slDataTypeAccess;
#endif

#define INVALID_DTYPE_ID       (-10)
#define INVALID_DTYPE_SIZE     (-1)
#define INVALID_DTYPE_SIGNED   (-1)
#define INVALID_NUM_DTYPES     (-1)

typedef enum {
    BD_ERR_VALUE_NONE,
    BD_ERR_VALUE_WARNING,
    BD_ERR_VALUE_ERROR
} BDErrorValue;

typedef enum {
    GEN_DTA_INT_PROP_SIZE,
    GEN_DTA_INT_PROP_STORAGE_ID,
    GEN_DTA_INT_PROP_ID_ALIASED_THRU_TO,
    GEN_DTA_INT_PROP_PROPERTIES_SIZE,
    GEN_DTA_INT_PROP_ID_ALIASED_TO,
    GEN_DTA_INT_PROP_NUM_ELEMENTS,
    GEN_DTA_INT_PROP_IS_BUS,
    GEN_DTA_INT_PROP_IS_ENUMTYPE,
    GEN_DTA_INT_PROP_ENUMTYPE_NUMSTRINGS,
    GEN_DTA_INT_PROP_ENUMTYPE_INDEX_OF_DEFAULT,
    GEN_DTA_INT_PROP_ENUMTYPE_ADD_TYPENAME_AS_PREFIX,
    GEN_DTA_INT_PROP_IS_BUS_WITH_VARDIMS_ELEMENT,
    GEN_DTA_INT_PROP_VARDIMS_SIZE
} GenDTAIntPropType;

typedef enum {
    GEN_DTA_INT_PROP_ELEMENT_DATA_TYPE,
    GEN_DTA_INT_PROP_ELEMENT_SIGNAL_TYPE,
    GEN_DTA_INT_PROP_ELEMENT_NUM_DIMENSIONS,
    GEN_DTA_INT_PROP_ELEMENT_OFFSET,
    GEN_DTA_INT_PROP_ENUMTYPE_INDEX_FROM_VALUE,
    GEN_DTA_INT_PROP_ENUMTYPE_VALUE_FROM_INDEX,
    GEN_DTA_INT_PROP_ELEMENT_DIMENSIONS_MODE,
    GEN_DTA_INT_PROP_ELEMENT_VARDIMS_OFFSET
} GenDTAIntElemPropType;

typedef enum {
    GEN_DTA_VOID_PROP_NAME,
    GEN_DTA_VOID_PROP_ZERO,
    GEN_DTA_VOID_PROP_PROPERTIES,
    GEN_DTA_VOID_PROP_OBJECT,
    GEN_DTA_VOID_PROP_CGTYPE
} GenDTAVoidPropType;

typedef enum {
    GEN_DTA_VOID_PROP_ELEMENT_NAME,
    GEN_DTA_VOID_PROP_ELEMENT_DIMENSIONS,
    GEN_DTA_VOID_PROP_ENUMTYPE_STRING_FROM_VALUE,
    GEN_DTA_VOID_PROP_ENUMTYPE_STRING_FROM_INDEX
} GenDTAVoidElemPropType;

typedef enum {
    GEN_DTA_REAL_PROP_ELEMENT_MIN,
    GEN_DTA_REAL_PROP_ELEMENT_MAX
} GenDTARealElemPropType;

typedef enum {
    GEN_DTA_UNARY_FCN_IS_POSITIVE,
    GEN_DTA_UNARY_FCN_IS_NEGATIVE
} GenDTAUnaryFcnType;

typedef enum {
    GEN_DTA_BINARY_FCN_GREATER_THAN,
    GEN_DTA_BINARY_FCN_GREATER_EQUAL
} GenDTABinaryFcnType;

typedef enum {
    GEN_DTA_DATA_OVERFLOW,
    GEN_DTA_INT32_TO_FLOAT,
    GEN_DTA_PARAMETER_OVERFLOW,
    GEN_DTA_PARAMETER_PRECISION_LOSS,
    GEN_DTA_PARAMETER_DOWNCAST,
    GEN_DTA_PARAMETER_UNDERFLOW
} GenDTADiagnosticType;

typedef void * (*RegisterDataTypeWithCheck) (void *, const char_T *, const char_T *, DTypeId *);

typedef DTypeId (*RegisterDataType) (void *, const char_T *, const char_T *);

typedef int_T (*GetNumDataTypes) (void *);

typedef DTypeId (*GetDataTypeId) (void *, const char_T *);

typedef int_T (*GetGenericDTAIntProp) (void *, const char_T *, DTypeId,
                                       GenDTAIntPropType);
typedef int_T (*SetGenericDTAIntProp) (void *, const char_T *, DTypeId, int_T,
                                       GenDTAIntPropType);
typedef int_T (*GetGenericDTAIntElemProp) (void *, const char_T *, DTypeId,
                                           int_T, GenDTAIntElemPropType);
typedef int_T (*SetGenericDTAIntElemProp) (void *, const char_T *, DTypeId,
                                           int_T, int_T, GenDTAIntElemPropType);
typedef real_T (*GetGenericDTARealElemProp) (void *, const char_T *, DTypeId,
                                            int_T, GenDTARealElemPropType);
typedef int_T  (*SetGenericDTARealElemProp) (void *, const char_T *, DTypeId,
                                            int_T, int_T, GenDTARealElemPropType);

typedef const void* (*GetGenericDTAVoidProp) (void *, const char_T *, DTypeId,
                                              GenDTAVoidPropType);
typedef int_T (*SetGenericDTAVoidProp) (void *, const char_T *, DTypeId,
                                        const void *, GenDTAVoidPropType);
typedef const void* (*GetGenericDTAVoidElemProp) (void *, const char_T *,
                                                  DTypeId, int_T,
                                                  GenDTAVoidElemPropType);
typedef int_T (*SetGenericDTAVoidElemProp) (void *, const char_T *, DTypeId,
                                 int_T, const void *, GenDTAVoidElemPropType);

typedef int_T (*ConvertBetweenFcn) (slDataTypeAccess *, const char_T *,
                                    DTypeId, DTypeId, int_T, const void *,
                                    const void *, void *);
typedef ConvertBetweenFcn (*GetConvertBetweenFcn) (void *, const char_T *,
                                                   DTypeId);
typedef int_T (*SetConvertBetweenFcn) (void *, const char_T *, DTypeId,
                                       ConvertBetweenFcn);

typedef int_T (*GenericDTAUnaryFcn) (slDataTypeAccess *, const char_T *,
                                     DTypeId, int_T, const void *,
                                     const void *, void *);
typedef GenericDTAUnaryFcn (*GetGenericDTAUnaryFcnGW) (void *, const char_T *,
                                                       DTypeId,
                                                       GenDTAUnaryFcnType);
typedef int_T  (*SetGenericDTAUnaryFcnGW) (void *, const char_T *, DTypeId,
                                           GenericDTAUnaryFcn,
                                           GenDTAUnaryFcnType);
typedef int_T (*GenericDTAUnaryFcnGW) (slDataTypeAccess *, DTypeId, int_T,
                                       const void *, const void *, void *,
                                       GenDTAUnaryFcnType);


typedef int_T (*GenericDTABinaryFcn) (slDataTypeAccess *, const char_T *,
                                      DTypeId, int_T, const void *,
                                      const void *, const void *, void *);
typedef GenericDTABinaryFcn (*GetGenericDTABinaryFcnGW) (void *, const char_T *,
                                                         DTypeId,
                                                         GenDTABinaryFcnType);
typedef int_T (*SetGenericDTABinaryFcnGW) (void *, const char_T *,
                                           DTypeId, GenericDTABinaryFcn,
                                           GenDTABinaryFcnType);
typedef int_T (*GenericDTABinaryFcnGW) (slDataTypeAccess *, DTypeId,
                                        int_T, const void *,
                                        const void *, const void *,
                                        void *, GenDTABinaryFcnType);

typedef int_T (*GetGenericDTADiagnostic) (void *, const char_T *,
                                          GenDTADiagnosticType,
                                          BDErrorValue *);

struct _slDataTypeAccess_tag {
    void                      *dataTypeTable;

    const char_T              *errorString;

    RegisterDataType          registerFcn;

    GetNumDataTypes           getNumDataTypesFcn;

    GetDataTypeId             getIdFcn;

    GetGenericDTAIntProp      getGenericDTAIntProp;
    SetGenericDTAIntProp      setGenericDTAIntProp;

    GetGenericDTAVoidProp     getGenericDTAVoidProp;
    SetGenericDTAVoidProp     setGenericDTAVoidProp;

    GetGenericDTAUnaryFcnGW   getGenericDTAUnaryFcnGW;
    SetGenericDTAUnaryFcnGW   setGenericDTAUnaryFcnGW;

    GetGenericDTABinaryFcnGW  getGenericDTABinaryFcnGW;
    SetGenericDTABinaryFcnGW  setGenericDTABinaryFcnGW;

    GetConvertBetweenFcn      getConvertBetweenFcn;
    SetConvertBetweenFcn      setConvertBetweenFcn;

    GetGenericDTADiagnostic   getGenericDTADiagnostic;

    RegisterDataTypeWithCheck registerFcnWithCheck;

    GetGenericDTAIntElemProp  getGenericDTAIntElemProp;
    SetGenericDTAIntElemProp  setGenericDTAIntElemProp;

    GetGenericDTAVoidElemProp getGenericDTAVoidElemProp;
    SetGenericDTAVoidElemProp setGenericDTAVoidElemProp;
    
    GetGenericDTARealElemProp getGenericDTARealElemProp;
    SetGenericDTARealElemProp setGenericDTARealElemProp;    

};

#endif

/**
 * DataSetData.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class DataSetData  extends net.ivoa.SkyPortal.VOData  implements java.io.Serializable {
    private net.ivoa.SkyPortal._DataSetData_DataSet dataSet;

    public DataSetData() {
    }


    /**
     * Gets the dataSet value for this DataSetData.
     * 
     * @return dataSet
     */
    public net.ivoa.SkyPortal._DataSetData_DataSet getDataSet() {
        return dataSet;
    }


    /**
     * Sets the dataSet value for this DataSetData.
     * 
     * @param dataSet
     */
    public void setDataSet(net.ivoa.SkyPortal._DataSetData_DataSet dataSet) {
        this.dataSet = dataSet;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DataSetData)) return false;
        DataSetData other = (DataSetData) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.dataSet==null && other.getDataSet()==null) || 
             (this.dataSet!=null &&
              this.dataSet.equals(other.getDataSet())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getDataSet() != null) {
            _hashCode += getDataSet().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DataSetData.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "DataSetData"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dataSet");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "DataSet"));
        elemField.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">DataSetData>DataSet"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
